#!/bin/bash
set -eo pipefail

# 配置参数（按需修改）
WVP_IP=""               # 自动获取公网IP
MYSQL_PASS="Wvp@123456" # MySQL密码
REDIS_PASS="Wvp@123456" # Redis密码
ZLM_SECRET=$(uuidgen)   # 随机生成ZLMediaKit密钥
MEDIA_PORTS="30000-30500"

echo "====== WVP-PRO 一键安装脚本 (1GB内存优化版) ======"
echo "版本：2024.05.05-前端路径修复版"
echo "------------------------------------------------"

# ==================== 环境检查 ====================
check_environment() {
    echo "=== 环境验证 ==="
    [ "$(id -u)" = "0" ] || { echo "必须使用root用户"; exit 1; }
    grep -q "Ubuntu 22.04" /etc/os-release || { echo "仅支持Ubuntu 22.04"; exit 1; }
    echo "-> 系统版本验证通过"
    echo "-> 物理内存: $(free -m | awk '/Mem:/ {print $2}')MB"
}

# ==================== 内存优化 ====================
configure_swap() {
    echo "=== 内存优化 ==="
    if [ ! -f /swapfile ]; then
        echo "-> 创建4GB交换文件..."
        dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        echo "vm.swappiness=10" >> /etc/sysctl.conf
        sysctl -p
    fi
    echo "-> 当前内存状态:"
    free -h
}

# ==================== 依赖安装 ====================
install_dependencies() {
    echo "=== 安装系统依赖 ==="
    export DEBIAN_FRONTEND=noninteractive

    # 基础工具
    apt update && apt upgrade -y
    apt install -y git wget curl unzip make gcc g++ cmake

    # Java环境
    apt install -y openjdk-11-jdk maven

    # 数据库
    apt install -y mysql-server redis-server

    # 媒体组件
    apt install -y ffmpeg libssl-dev libsdl1.2-dev \
        libavcodec-dev libavutil-dev libavformat-dev

    # MongoDB
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt update
    apt install -y mongodb-org

    # Node.js 18 LTS
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
    npm config set registry https://registry.npmmirror.com
    npm install -g npm@latest --no-audit --fund=false

    echo "-> 依赖安装完成"
}

# ==================== 数据库配置 ====================
configure_databases() {
    echo "=== 数据库配置 ==="

    # 启动服务
    systemctl start mysql redis-server mongod

    # MySQL配置
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASS}';
CREATE DATABASE IF NOT EXISTS wvp DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'wvp'@'localhost' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL PRIVILEGES ON wvp.* TO 'wvp'@'localhost';
FLUSH PRIVILEGES;
EOF

    # Redis配置
    sed -i "s/# requirepass .*/requirepass ${REDIS_PASS}/" /etc/redis/redis.conf
    systemctl restart redis

    # MongoDB配置
    sleep 5  # 等待服务启动
    mongosh --eval 'db.getSiblingDB("wvp")'

    echo "-> 数据库配置完成"
}

# ==================== 编译ZLMediaKit ====================
compile_zlm() {
    echo "=== 编译ZLMediaKit ==="
    cd /opt
    [ ! -d ZLMediaKit ] && git clone --depth 1 https://github.com/ZLMediaKit/ZLMediaKit.git
    cd ZLMediaKit

    # 低内存编译优化
    git submodule update --init --depth 1
    cd 3rdpart/ZLToolKit
    mkdir build && cd build
    cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
    make -j1 && make install
    cd ../../../

    mkdir build && cd build
    cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
    make -j1

    # 生成配置文件
    cat > ../config.ini <<EOF
[api]
apiDebug=1
secret=${ZLM_SECRET}
defaultSnap=./www/static/logo.png

[http]
port=80
dir=./www
rootPath=/media

[hook]
enable=1
on_flow_report=http://${WVP_IP}:18080/index/hook/on_flow_report
on_http_access=http://${WVP_IP}:18080/index/hook/on_http_access
on_play=http://${WVP_IP}:18080/index/hook/on_play
on_publish=http://${WVP_IP}:18080/index/hook/on_publish
timeoutSec=10
EOF

    # 服务配置
    cat > /etc/systemd/system/zlmediakit.service <<EOF
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
MemoryLimit=512M

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable zlmediakit
    echo "-> ZLMediaKit编译完成"
}

# ==================== 编译WVP-PRO ====================
compile_wvp() {
    echo "=== 编译WVP-PRO ==="
    cd /opt
    [ ! -d wvp-GB28181-pro ] && git clone https://github.com/648540858/wvp-GB28181-pro.git
    cd wvp-GB28181-pro
    git pull

    # 后端编译（内存限制）
    echo "-> 编译Java后端..."
    export MAVEN_OPTS="-Xms256m -Xmx512m"
    mvn clean package -DskipTests -T 1C

    # 前端编译（新版web_src目录）
    echo "-> 编译前端资源..."
    if [ -d "web_src" ]; then
        cd web_src
        echo "--> 安装Node依赖..."
        npm install --force --no-audit --fund=false
        
        echo "--> 构建前端（内存限制1GB）..."
        export NODE_OPTIONS="--max-old-space-size=1024"
        for i in {1..3}; do
            npm run build && break || {
                echo "--> 构建失败，重试第${i}次...";
                npm cache clean --force;
                sleep 10;
            }
        done
        
        cd ..
        echo "--> 复制构建文件到web目录..."
        mkdir -p web
        cp -r web_src/dist/* web/
    else
        echo "错误：找不到前端目录 web_src/"
        exit 1
    fi

    echo "-> WVP-PRO编译完成"
}

# ==================== 应用配置 ====================
configure_application() {
    echo "=== 配置WVP-PRO ==="
    cd /opt/wvp-GB28181-pro

    # 生成配置文件
    cat > src/main/resources/application.yml <<EOF
server:
  ip: ${WVP_IP}
  port: 18080

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/wvp?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai
    username: wvp
    password: ${MYSQL_PASS}
  redis:
    host: ${WVP_IP}
    port: 6379
    password: ${REDIS_PASS}
  data:
    mongodb:
      uri: mongodb://localhost/wvp

sip:
  ip: ${WVP_IP}
  port: 5060
  domain: ${WVP_IP}
  id: 34020000002000000001
  password: admin123

media:
  id: 34020000002000000001
  ip: ${WVP_IP}
  http-port: 10000
  rtp:
    port-range: ${MEDIA_PORTS}
    enable: true

wvp:
  record:
    path: /opt/media/record
  snap:
    path: /opt/media/snap
  log:
    path: /opt/media/logs
EOF

    # 创建媒体目录
    mkdir -p /opt/media/{record,snap,logs}
    chmod -R 777 /opt/media

    # 服务配置
    cat > /etc/systemd/system/wvp.service <<EOF
[Unit]
Description=WVP-PRO Service
After=network.target mysql.service redis.service mongod.service

[Service]
Type=simple
ExecStart=/usr/bin/java -Xms256m -Xmx512m -jar target/wvp-pro-*.jar
WorkingDirectory=/opt/wvp-GB28181-pro
Restart=always
User=root
MemoryLimit=800M

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable wvp
}

# ==================== 防火墙配置 ====================
configure_firewall() {
    echo "=== 配置防火墙 ==="
    ufw --force reset
    ufw allow 22/tcp
    ufw allow 18080/tcp
    ufw allow 5060/tcp
    ufw allow 5060/udp
    ufw allow ${MEDIA_PORTS/%-*/}/udp  # 开放整个端口范围
    ufw --force enable
}

# ==================== 主流程 ====================
main() {
    # 获取公网IP
    WVP_IP=$(curl -s https://api.ipify.org || curl -s ifconfig.me || hostname -I | awk '{print $1}')
    read -p "请输入公网IP (默认 ${WVP_IP}): " input_ip
    WVP_IP=${input_ip:-$WVP_IP}
    echo "使用IP: ${WVP_IP}"

    check_environment
    configure_swap
    install_dependencies
    configure_databases
    compile_zlm
    compile_wvp
    configure_application
    configure_firewall

    # 启动服务
    systemctl start zlmediakit
    systemctl start wvp

    echo "====== 部署完成 ======"
    echo "访问地址: http://${WVP_IP}:18080"
    echo "默认账号: admin/admin"
    echo "监控命令:"
    echo "  journalctl -u wvp -f          # 查看实时日志"
    echo "  systemctl status zlmediakit   # 检查媒体服务状态"
    echo "重要端口:"
    echo "  - Web管理: 18080/tcp"
    echo "  - SIP信令: 5060/tcp+udp"
    echo "  - 媒体流: ${MEDIA_PORTS}/udp"
}

main