#!/bin/bash
set -e

echo "====== 开始部署 WVP-PRO 全流程环境 ======"
echo "官方文档参考：https://doc.wvp-pro.cn/#/"
echo "项目地址：https://github.com/648540858/wvp-GB28181-pro"

# 检查是否为root用户
if [ "$(id -u)" != "0" ]; then
   echo "错误：此脚本必须以root用户身份运行" 1>&2
   exit 1
fi

# 检查系统是否为Ubuntu 22.04
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "ubuntu" ] || [ "$VERSION_ID" != "22.04" ]; then
        echo "错误：此脚本仅支持Ubuntu 22.04系统"
        exit 1
    fi
else
    echo "错误：无法确定操作系统类型"
    exit 1
fi

# 自动获取公网 IP
PUB_IP=$(curl -s https://api.ipify.org || echo "127.0.0.1")
read -p "检测到本机公网IP为 $PUB_IP，按回车确认或手动输入新IP: " input_ip
IP=${input_ip:-$PUB_IP}

echo "本机公网 IP 设置为：$IP"

# 更新系统并安装基础依赖
echo "=== 更新系统并安装基础依赖 ==="
export DEBIAN_FRONTEND=noninteractive
apt update && apt upgrade -y
apt install -y git wget curl unzip make gcc g++ cmake openjdk-11-jdk maven redis-server ufw \
    npm nodejs ffmpeg libssl-dev libsdl-dev libavcodec-dev libavutil-dev libavformat-dev

# 检查npm版本，如果版本低于7则升级
npm_version=$(npm -v | cut -d'.' -f1)
if [ "$npm_version" -lt 7 ]; then
    echo "升级npm版本..."
    npm install -g npm@latest
fi

# === 安装 MySQL ===
echo "=== 安装 MySQL ==="
apt install -y mysql-server
systemctl enable mysql
systemctl start mysql

# 初始化数据库
echo "初始化MySQL数据库..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS wvp DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'wvp'@'localhost' IDENTIFIED BY 'wvp123456';
GRANT ALL PRIVILEGES ON wvp.* TO 'wvp'@'localhost';
FLUSH PRIVILEGES;
EOF

# === 安装 MongoDB（使用官方源）===
echo "=== 安装 MongoDB ==="
if [ ! -f /usr/share/keyrings/mongodb.gpg ]; then
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb.gpg
    echo "deb [ arch=amd64, signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt update
fi
apt install -y mongodb-org
systemctl enable mongod
systemctl start mongod

# 等待MongoDB启动
sleep 5
echo "初始化MongoDB数据库..."
mongo --eval 'db.getSiblingDB("wvp")'

# === 编译 ZLMediaKit ===
echo "=== 编译 ZLMediaKit ==="
cd /opt
if [ ! -d ZLMediaKit ]; then
    git clone --depth 1 https://github.com/ZLMediaKit/ZLMediaKit.git
fi
cd ZLMediaKit
git submodule update --init
mkdir -p build && cd build
cmake .. -DENABLE_WEBRTC=on -DENABLE_SRT=on
make -j$(nproc)

# 创建ZLMediaKit配置文件
cat <<EOF >../config.ini
[api]
apiDebug=1
secret=035c73f7-bb6b-4889-a715-d9eb2d1925cc
defaultSnap=./www/static/logo.png

[http]
port=80
dir=./www
rootPath=/media

[multicast]
addr=224.0.0.1
port=6000
ttl=64

[record]
appName=record
sampleMS=1000
fastStart=0
fileBufSize=65536
fileRepeat=0

[rtp_proxy]
port=10000
timeoutSec=15

[rtsp]
port=554
sslPort=332

[shell]
port=9000

[general]
enableVhost=0
flowThreshold=1024
streamNoneReaderDelayMS=20000
resetWhenRePlay=1
publishToHls=1
mergeWriteMS=0
wait_track_ready_ms=10000
wait_add_track_ms=3000
unready_frame_cache=1

[hook]
enable=1
on_flow_report=https://$IP:18080/index/hook/on_flow_report
on_http_access=https://$IP:18080/index/hook/on_http_access
on_play=https://$IP:18080/index/hook/on_play
on_publish=https://$IP:18080/index/hook/on_publish
on_record_mp4=https://$IP:18080/index/hook/on_record_mp4
on_rtsp_auth=https://$IP:18080/index/hook/on_rtsp_auth
on_rtsp_realm=https://$IP:18080/index/hook/on_rtsp_realm
on_shell_login=https://$IP:18080/index/hook/on_shell_login
on_stream_changed=https://$IP:18080/index/hook/on_stream_changed
on_stream_none_reader=https://$IP:18080/index/hook/on_stream_none_reader
on_stream_not_found=https://$IP:18080/index/hook/on_stream_not_found
on_server_started=https://$IP:18080/index/hook/on_server_started
timeoutSec=10
EOF

# 创建ZLMediaKit服务
cat <<EOF >/etc/systemd/system/zlmediakit.service
[Unit]
Description=ZLMediaKit Service
After=network.target

[Service]
Type=simple
ExecStart=/opt/ZLMediaKit/build/MediaServer -c /opt/ZLMediaKit/config.ini -d
WorkingDirectory=/opt/ZLMediaKit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zlmediakit
systemctl start zlmediakit

# === 编译 WVP-PRO 后端 ===
echo "=== 编译 WVP-PRO 后端 ==="
cd /opt
if [ ! -d wvp-GB28181-pro ]; then
    git clone https://github.com/648540858/wvp-GB28181-pro.git
fi
cd wvp-GB28181-pro
git pull
mvn clean package -DskipTests

# === 编译前端页面 ===
echo "=== 编译前端页面 ==="
cd /opt/wvp-GB28181-pro/wvp-pro-web
npm install --force
npm run build

# === 编辑 application.yml 配置文件 ===
echo "=== 编辑 application.yml 配置文件 ==="

# 备份原始配置文件
cp /opt/wvp-GB28181-pro/src/main/resources/application.yml /opt/wvp-GB28181-pro/src/main/resources/application.yml.bak

# 设置 MySQL 配置
sed -i "s|spring.datasource.url: jdbc:mysql://.*|spring.datasource.url: jdbc:mysql://localhost:3306/wvp?useUnicode=true\&characterEncoding=UTF8\&rewriteBatchedStatements=true\&allowMultiQueries=true\&serverTimezone=Asia/Shanghai|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|spring.datasource.username:.*|spring.datasource.username: wvp|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|spring.datasource.password:.*|spring.datasource.password: wvp123456|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 设置 Redis 配置
sed -i "s|spring.redis.host:.*|spring.redis.host: $IP|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|spring.redis.port:.*|spring.redis.port: 6379|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|spring.redis.password:.*|spring.redis.password: \"\"|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 设置 MongoDB 配置
sed -i "s|spring.data.mongodb.uri:.*|spring.data.mongodb.uri: mongodb://localhost:27017/wvp|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 设置 SIP 配置
sed -i "s|sip.ip:.*|sip.ip: $IP|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|sip.port:.*|sip.port: 5060|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|sip.domain:.*|sip.domain: $IP|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|sip.id:.*|sip.id: 34020000002000000001|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|sip.password:.*|sip.password: 12345678|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 设置媒体配置
sed -i "s|media.id:.*|media.id: 34020000002000000001|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|media.ip:.*|media.ip: $IP|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|media.port:.*|media.port: 10000|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|media.rtp.port-range:.*|media.rtp.port-range: 30000-30500|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|media.rtp.enable:.*|media.rtp.enable: true|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|media.rtp.ssl:.*|media.rtp.ssl: false|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 设置其他配置
sed -i "s|server.address:.*|server.address: $IP|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|server.port:.*|server.port: 18080|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|server.ssl.enable:.*|server.ssl.enable: false|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|wvp.record.path:.*|wvp.record.path: /opt/media/record|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|wvp.snap.path:.*|wvp.snap.path: /opt/media/snap|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml
sed -i "s|wvp.log.path:.*|wvp.log.path: /opt/media/logs|g" /opt/wvp-GB28181-pro/src/main/resources/application.yml

# 创建媒体目录
mkdir -p /opt/media/{record,snap,logs}
chmod -R 777 /opt/media

# === 设置 UFW 防火墙放开端口 ===
echo "=== 配置 UFW 防火墙放开相关端口 ==="
ufw --force reset
ufw allow 22/tcp     # SSH
ufw allow 18080/tcp  # WVP-PRO Web 服务
ufw allow 6379/tcp   # Redis
ufw allow 27017/tcp  # MongoDB
ufw allow 3306/tcp   # MySQL
ufw allow 5060/udp   # SIP
ufw allow 5060/tcp   # SIP
ufw allow 10000/tcp  # ZLMediaKit
ufw allow 30000:30500/udp  # RTP端口范围
ufw allow 554/tcp    # RTSP
ufw allow 80/tcp     # HTTP
ufw --force enable

# === 创建服务 systemd 配置 ===
echo "=== 设置 WVP-PRO 开机自启 ==="
cat <<EOF >/etc/systemd/system/wvp.service
[Unit]
Description=WVP-PRO GB28181 Service
After=network.target mysql.service redis.service mongod.service zlmediakit.service

[Service]
Type=simple
ExecStart=/usr/bin/java -jar /opt/wvp-GB28181-pro/target/wvp-pro-*.jar
WorkingDirectory=/opt/wvp-GB28181-pro
Restart=always
RestartSec=3
User=root
Environment="JAVA_OPTS=-Xmx2g -Xms512m"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wvp
systemctl start wvp

# === 安装完成后的检查 ===
echo "=== 安装完成，正在检查服务状态 ==="

# 检查服务状态
services=("mysql" "redis-server" "mongod" "zlmediakit" "wvp")
for service in "${services[@]}"; do
    status=$(systemctl is-active "$service")
    if [ "$status" = "active" ]; then
        echo "$service 服务运行正常"
    else
        echo "警告：$service 服务未正常运行，当前状态: $status"
        echo "尝试重新启动服务..."
        systemctl restart "$service"
    fi
done

# 检查端口监听情况
echo "检查端口监听情况："
netstat -tulnp | grep -E "18080|5060|10000|30000|6379|27017|3306"

echo "====== ✅ WVP-PRO 部署完成！ ======"
echo "访问地址：http://$IP:18080"
echo "默认用户名：admin"
echo "默认密码：admin"
echo "请及时修改默认密码！"
echo "ZLMediaKit管理端口：9000"
echo "SIP服务器地址：$IP:5060"
echo "媒体流端口范围：30000-30500/udp"
