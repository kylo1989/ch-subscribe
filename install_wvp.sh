#!/bin/bash
set -e

echo "====== 开始部署 WVP-PRO 全流程环境 ======"

# 自动获取公网 IP
PUB_IP=$(curl -s https://api.ipify.org)
read -p "检测到本机公网IP为 $PUB_IP，按回车确认或手动输入新IP: " input_ip
IP=${input_ip:-$PUB_IP}

echo "本机公网 IP 设置为：$IP"

# 基础依赖安装
apt update && apt upgrade -y
apt install -y git wget curl unzip make gcc g++ cmake openjdk-11-jdk maven redis-server

# === 安装 MySQL ===
echo "=== 安装 MySQL ==="
apt install -y mysql-server
systemctl enable mysql
systemctl start mysql

# 初始化数据库
mysql -u root <<EOF
CREATE DATABASE wvp;
CREATE USER 'wvp'@'localhost' IDENTIFIED BY 'wvp123456';
GRANT ALL PRIVILEGES ON wvp.* TO 'wvp'@'localhost';
FLUSH PRIVILEGES;
EOF

# === 安装 MongoDB（使用官方源）===
echo "=== 安装 MongoDB ==="
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb.gpg
echo "deb [ arch=amd64, signed-by=/usr/share/keyrings/mongodb.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

apt update
apt install -y mongodb-org
systemctl enable mongod
systemctl start mongod

# === 编译 ZLMediaKit ===
echo "=== 编译 ZLMediaKit ==="
cd /opt
git clone https://github.com/ZLMediaKit/ZLMediaKit.git
cd ZLMediaKit
mkdir build && cd build
cmake ..
make -j$(nproc)

# === 编译 WVP-PRO 后端 ===
echo "=== 编译 WVP-PRO 后端 ==="
cd /opt
git clone https://github.com/648540858/wvp-GB28181-pro.git
cd wvp-GB28181-pro
sed -i "s/127.0.0.1/$IP/g" ./src/main/resources/application.yml
mvn clean package -DskipTests

# === 编译前端 ===
echo "=== 编译前端页面 ==="
cd /opt/wvp-GB28181-pro/wvp-pro-web
npm install
npm run build

# === 创建服务 systemd 配置 ===
echo "=== 设置 WVP-PRO 开机自启 ==="
cat <<EOF >/etc/systemd/system/wvp.service
[Unit]
Description=WVP-PRO GB28181 Service
After=network.target mysql.service redis.service mongod.service

[Service]
Type=simple
ExecStart=/usr/bin/java -jar /opt/wvp-GB28181-pro/target/wvp-pro-*.jar
WorkingDirectory=/opt/wvp-GB28181-pro
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable wvp
systemctl start wvp

echo "====== ✅ WVP-PRO 部署完成！请访问：http://$IP:18080 ======"
