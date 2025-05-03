#!/bin/bash
set -e

echo "====== 开始部署 WVP-PRO 全流程环境 (1GB内存优化版) ======"
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

# ==================== 内存优化措施 ====================
echo "=== 为1GB内存VPS优化 ==="

# 创建4GB交换空间
if [ ! -f /swapfile ]; then
    echo "创建4GB交换文件..."
    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    echo "vm.swappiness = 10" >> /etc/sysctl.conf
    sysctl -p
fi

# 显示内存信息
echo "当前内存状态："
free -h

# ==================== 安装依赖 ====================
echo "=== 更新系统并安装基础依赖 ==="
export DEBIAN_FRONTEND=noninteractive

# 分批安装依赖以避免内存不足
apt update && apt upgrade -y
apt install -y git wget curl unzip make gcc g++ cmake
apt install -y openjdk-11-jdk maven redis-server ufw
apt install -y npm nodejs ffmpeg libssl-dev libsdl1.2-dev
apt install -y libavcodec-dev libavutil-dev libavformat-dev mongodb-mongosh

# 检查npm版本
npm_version=$(npm -v | cut -d'.' -f1)
if [ "$npm_version" -lt 7 ]; then
    echo "升级npm版本..."
    npm install -g npm@latest --no-audit --fund=false --progress=false
fi

# ==================== 安装MySQL ====================
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

# ==================== 安装MongoDB ====================
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
mongosh --eval 'db.getSiblingDB("wvp")'

# ==================== 编译ZLMediaKit (低内存优化) ====================
echo "=== 编译 ZLMediaKit (1GB内存优化) ==="

cd /opt
if [ ! -d ZLMediaKit ]; then
    git clone --depth 1 https://github.com/ZLMediaKit/ZLMediaKit.git
fi
cd ZLMediaKit
git submodule update --init --depth 1

# 分批编译ZLToolKit依赖
echo "先编译ZLToolKit依赖..."
cd 3rdpart/ZLToolKit
mkdir -p build && cd build
cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
make -j1
make install
cd ../../../

# 主程序编译
echo "开始主程序编译..."
mkdir -p build && cd build
cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
echo "使用单线程编译避免OOM..."
make -j1

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

[hook]
enable=1
on_flow_report=https://$IP:18080/index/hook/on_flow_report
on_http_access=https://$IP:18080/index/hook/on_http_access
on_play=https://$IP:18080/index/hook/on_play
on_publish=https://$IP:18080/index/hook/on_publish
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
Environment="LD_LIBRARY_PATH=/usr/local/lib"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable zlmediakit
systemctl start zlmediakit

# ==================== 编译WVP-PRO (内存优化) ====================
echo "=== 编译 WVP-PRO 后端 ==="
cd /opt
if [ ! -d wvp-GB28181-pro ]; then
    git clone --depth 1 https://github.com/648540858/wvp-GB28181-pro.git
fi
cd wvp-GB28181-pro

# 限制Maven内存使用
export MAVEN_OPTS="-Xms256m -Xmx512m"
mvn clean package -DskipTests -T 1C

echo "=== 编译前端页面 ==="
cd wvp-pro-web
npm install --force --no-audit --fund=false --progress=false
npm run build

# ==================== 配置文件修改 ====================
echo "=== 编辑 application.yml 配置文件 ==="

# 备份原始配置文件
cp src/main/resources/application.yml src/main/resources/application.yml.bak

# 使用sed进行安全替换
sed -i "s|spring.datasource.url:.*|spring.datasource.url: jdbc:mysql://localhost:3306/wvp?useUnicode=true\&characterEncoding=UTF8\&rewriteBatchedStatements=true\&allowMultiQueries=true\&serverTimezone=Asia/Shanghai|g" src/main/resources/application.yml
sed -i "s|spring.datasource.username:.*|spring.datasource.username: wvp|g" src/main/resources/application.yml
sed -i "s|spring.datasource.password:.*|spring.datasource.password: wvp123456|g" src/main/resources/application.yml
sed -i "s|spring.redis.host:.*|spring.redis.host: $IP|g" src/main/resources/application.yml
sed -i "s|spring.data.mongodb.uri:.*|spring.data.mongodb.uri: mongodb://localhost:27017/wvp|g" src/main/resources/application.yml
sed -i "s|sip.ip:.*|sip.ip: $IP|g" src/main/resources/application.yml
sed -i "s|media.ip:.*|media.ip: $IP|g" src/main/resources/application.yml
sed -i "s|media.rtp.port-range:.*|media.rtp.port-range: 30000-30500|g" src/main/resources/application.yml

# 创建媒体目录
mkdir -p /opt/media/{record,snap,logs}
chmod -R 777 /opt/media

# ==================== 防火墙配置 ====================
echo "=== 配置防火墙 ==="
ufw --force reset
ufw allow 22/tcp
ufw allow 18080/tcp
ufw allow 5060/tcp
ufw allow 5060/udp
ufw allow 10000/tcp
ufw allow 30000:30500/udp
ufw allow 554/tcp
ufw allow 80/tcp
ufw --force enable

# ==================== 创建WVP服务 ====================
echo "=== 设置 WVP-PRO 服务 ==="
cat <<EOF >/etc/systemd/system/wvp.service
[Unit]
Description=WVP-PRO GB28181 Service
After=network.target mysql.service redis.service mongod.service zlmediakit.service

[Service]
Type=simple
ExecStart=/usr/bin/java -Xms256m -Xmx512m -jar /opt/wvp-GB28181-pro/target/wvp-pro-*.jar
WorkingDirectory=/opt/wvp-GB28181-pro
Restart=always
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wvp
systemctl start wvp

# ==================== 安装完成检查 ====================
echo "=== 安装完成检查 ==="
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

echo "====== ✅ WVP-PRO 部署完成！ ======"
echo "访问地址：http://$IP:18080"
echo "默认用户名：admin"
echo "默认密码：admin"
echo "请及时修改默认密码！"
echo "ZLMediaKit管理端口：9000"
echo "SIP服务器地址：$IP:5060"
echo "媒体流端口范围：30000-30500/udp"
echo "交换空间状态："
free -h