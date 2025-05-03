#!/bin/bash
set -e

echo "====== 1GB内存VPS专用WVP-PRO安装脚本 ======"
echo "优化措施："
echo "1. 自动配置4GB交换空间"
echo "2. Node.js内存限制设置"
echo "3. 分段式编译安装"
echo "4. 服务内存限制配置"
echo "5. 智能重试机制"

# 环境检查
check_environment() {
    if [ "$(id -u)" != "0" ]; then
        echo "错误：必须使用root用户运行" >&2
        exit 1
    fi

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        [ "$ID" = "ubuntu" ] && [ "$VERSION_ID" = "22.04" ] || {
            echo "错误：仅支持Ubuntu 22.04" >&2
            exit 1
        }
    else
        echo "错误：无法确定系统版本" >&2
        exit 1
    fi

    TOTAL_MEM=$(free -m | awk '/Mem:/ {print $2}')
    echo "当前物理内存: ${TOTAL_MEM}MB"
}

# 内存优化配置
configure_swap() {
    if [ ! -f /swapfile ]; then
        echo "创建4GB交换文件..."
        fallocate -l 4G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        echo "vm.swappiness=10" >> /etc/sysctl.conf
        sysctl -p
    fi
    echo "当前内存状态:"
    free -h
}

# 基础依赖安装（分段式）
install_dependencies() {
    echo "=== 分批安装依赖 ==="
    apt update && apt upgrade -y
    
    # 分阶段安装避免内存不足
    local deps_stage1="git wget curl unzip make gcc g++ cmake"
    local deps_stage2="openjdk-11-jdk maven redis-server ufw"
    local deps_stage3="npm nodejs ffmpeg libssl-dev libsdl1.2-dev"
    local deps_stage4="libavcodec-dev libavutil-dev libavformat-dev mongodb-mongosh"
    
    apt install -y $deps_stage1
    apt install -y $deps_stage2
    apt install -y $deps_stage3
    apt install -y $deps_stage4

    # 配置npm
    npm config set registry https://registry.npmmirror.com
    npm install -g npm@latest --no-audit --fund=false --progress=false
}

# 数据库配置
configure_databases() {
    # MySQL
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS wvp DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER 'wvp'@'localhost' IDENTIFIED BY 'wvp123456';
GRANT ALL PRIVILEGES ON wvp.* TO 'wvp'@'localhost';
FLUSH PRIVILEGES;
EOF

    # MongoDB
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-6.0.list
    apt update
    apt install -y mongodb-org
    systemctl enable mongod
    systemctl start mongod
    sleep 5
    mongosh --eval 'db.getSiblingDB("wvp")'
}

# ZLMediaKit编译优化
compile_zlmediakit() {
    cd /opt
    [ ! -d ZLMediaKit ] && git clone --depth 1 https://github.com/ZLMediaKit/ZLMediaKit.git
    cd ZLMediaKit
    git submodule update --init --depth 1

    # 分步编译
    cd 3rdpart/ZLToolKit
    mkdir -p build && cd build
    cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
    make -j1
    make install
    cd ../../../
    
    mkdir -p build && cd build
    cmake .. -DENABLE_WEBRTC=off -DENABLE_SRT=off
    echo "使用单线程编译ZLMediaKit..."
    make -j1

    # 配置
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

    # 服务配置
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
MemoryLimit=512M
[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable zlmediakit
}

# WVP-PRO编译优化
compile_wvp() {
    cd /opt
    [ ! -d wvp-GB28181-pro ] && git clone --depth 1 https://github.com/648540858/wvp-GB28181-pro.git
    cd wvp-GB28181-pro
    git pull

    # 后端编译
    export MAVEN_OPTS="-Xms256m -Xmx512m"
    mvn clean package -DskipTests -T 1C

    # 前端编译（内存优化版）
    compile_frontend
}

# 前端编译（带内存限制和重试）
compile_frontend() {
    echo "=== 内存优化前端编译 ==="
    local frontend_dir=""
    [ -d "web_src" ] && frontend_dir="web_src"
    [ -d "wvp-pro-web" ] && frontend_dir="wvp-pro-web"
    
    if [ -z "$frontend_dir" ]; then
        echo "警告：未找到前端目录，跳过前端编译"
        return
    fi

    cd $frontend_dir
    
    # 清理并更新依赖
    rm -rf node_modules
    npm install core-js@latest @fingerprintjs/fingerprintjs --no-audit --fund=false --progress=false
    npm install --force --no-audit --fund=false --progress=false
    
    # 带内存限制的构建
    export NODE_OPTIONS="--max-old-space-size=1024"
    
    for attempt in {1..3}; do
        if [ -f "build/build.js" ]; then
            echo "尝试构建 (第${attempt}次)..."
            if node --max-old-space-size=1024 build/build.js; then
                break
            else
                echo "构建失败，清理缓存..."
                npm cache clean --force
                rm -rf node_modules/.cache
            fi
        fi
    done
    
    cd ..
    
    # 处理构建结果
    if [ "$frontend_dir" = "web_src" ] && [ -d "web_src/dist" ]; then
        mkdir -p web
        cp -r web_src/dist/* web/
    fi
}

# 服务配置
configure_services() {
    # 配置文件修改
    cd /opt/wvp-GB28181-pro
    cp src/main/resources/application.yml src/main/resources/application.yml.bak
    
    sed -i "s|spring.datasource.url:.*|jdbc:mysql://localhost:3306/wvp?useUnicode=true\&characterEncoding=UTF8|g" src/main/resources/application.yml
    sed -i "s|spring.datasource.username:.*|wvp|g" src/main/resources/application.yml
    sed -i "s|spring.datasource.password:.*|wvp123456|g" src/main/resources/application.yml
    sed -i "s|spring.redis.host:.*|$IP|g" src/main/resources/application.yml
    sed -i "s|media.ip:.*|$IP|g" src/main/resources/application.yml

    # WVP服务配置
    cat <<EOF >/etc/systemd/system/wvp.service
[Unit]
Description=WVP-PRO Service
After=network.target mysql.service redis.service mongod.service
[Service]
Type=simple
ExecStart=/usr/bin/java -Xms256m -Xmx512m -jar /opt/wvp-GB28181-pro/target/wvp-pro-*.jar
WorkingDirectory=/opt/wvp-GB28181-pro
Restart=always
RestartSec=10
User=root
MemoryLimit=800M
[Install]
WantedBy=multi-user.target
EOF

    # 防火墙
    ufw --force reset
    ufw allow 22/tcp
    ufw allow 18080/tcp
    ufw allow 30000:30500/udp
    ufw --force enable

    systemctl daemon-reload
    systemctl enable wvp
}

# 主流程
main() {
    check_environment
    configure_swap
    
    # 获取IP
    PUB_IP=$(curl -s https://api.ipify.org || hostname -I | awk '{print $1}')
    read -p "请输入公网IP (默认: $PUB_IP): " IP
    IP=${IP:-$PUB_IP}
    echo "使用IP: $IP"

    install_dependencies
    configure_databases
    compile_zlmediakit
    compile_wvp
    configure_services

    # 启动服务
    systemctl start zlmediakit
    systemctl start wvp

    echo "====== 安装完成 ======"
    echo "访问地址: http://$IP:18080"
    echo "用户名: admin"
    echo "密码: admin"
    echo "监控命令:"
    echo "  journalctl -u wvp -f"
    echo "  systemctl status zlmediakit"
}

main