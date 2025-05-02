#!/bin/bash

set -e

echo "====== 开始部署 WVP-PRO 全流程环境 ======"

# 获取公网 IP
read -p "请输入本机公网IP（将写入配置文件用于推流等）: " PUBLIC_IP

# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装基础依赖
sudo apt install -y git curl wget unzip build-essential cmake make gcc g++ \
    openjdk-11-jdk maven redis-server mysql-server gnupg2 software-properties-common

# 启用 Redis 和 MySQL 开机自启
sudo systemctl enable redis-server
sudo systemctl enable mysql

# 安装 MongoDB 6.0
echo "开始安装 MongoDB 6.0..."

# 导入 MongoDB 公共 GPG key
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | \
    sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg

# 添加官方源
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] \
https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# 更新包索引
sudo apt update

# 安装 MongoDB
sudo apt install -y mongodb-org

# 启动并设置开机自启
sudo systemctl enable mongod
sudo systemctl start mongod

echo "✅ MongoDB 安装完成并启动成功"

# 编译 ZLMediaKit
echo "开始编译 ZLMediaKit..."
cd ~
git clone https://github.com/ZLMediaKit/ZLMediaKit.git
cd ZLMediaKit
mkdir -p release/linux
cd release/linux
cmake ../../
make -j$(nproc)
echo "✅ ZLMediaKit 编译完成"

# 下载并构建 WVP-PRO 后端
echo "开始构建 WVP-PRO 后端..."
cd ~
git clone https://github.com/648540858/wvp-GB28181-pro.git wvp-pro
cd wvp-pro
mvn clean package -DskipTests
echo "✅ WVP-PRO 后端构建完成"

# 下载并构建前端页面
echo "开始构建 WVP-PRO 前端..."
cd ~
git clone https://github.com/648540858/wvp-GB28181-web.git wvp-web
cd wvp-web
# 安装 Node.js 和 npm
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs
npm install
npm run build
echo "✅ WVP-PRO 前端构建完成"

# 配置 WVP-PRO
echo "开始配置 WVP-PRO..."
cd ~/wvp-pro
cat > application.yml <<EOF
server:
  port: 18080

media:
  id: 123456
  ip: ${PUBLIC_IP}
  hookIp: ${PUBLIC_IP}
  sdpIp: ${PUBLIC_IP}
  stream-ip: ${PUBLIC_IP}
  http-port: 80
  rtp:
    port-range: 30000,30500

redis:
  host: 127.0.0.1
  port: 6379

spring:
  data:
    mongodb:
      uri: mongodb://127.0.0.1:27017/wvp
EOF
echo "✅ WVP-PRO 配置完成"

# 设置 WVP-PRO 服务开机自启
echo "设置 WVP-PRO 服务开机自启..."
sudo tee /etc/systemd/system/wvp.service > /dev/null <<EOF
[Unit]
Description=WVP-PRO Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/java -jar /root/wvp-pro/target/wvp-pro-*.jar
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable wvp
sudo systemctl start wvp
echo "✅ WVP-PRO 服务已启动并设置为开机自启"

echo "🎉 部署完成！WVP-PRO 已在 http://${PUBLIC_IP}:18080 上运行。"
