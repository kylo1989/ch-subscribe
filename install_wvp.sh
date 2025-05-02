#!/bin/bash

set -e

echo "====== 开始部署 WVP-PRO 全流程环境 ======"

read -p "请输入本机公网IP（将写入配置文件用于推流等）: " WVP_IP

# 安装基础依赖
apt update && apt install -y git curl wget unzip make cmake g++ gcc build-essential pkg-config libssl-dev libmysqlclient-dev libx264-dev libasio-dev libmicrohttpd-dev \
    redis-server mysql-server openjdk-11-jdk maven nginx ffmpeg mongodb

# 启动并设置 Redis、MySQL、MongoDB 开机自启
systemctl enable redis-server --now
systemctl enable mysql --now
systemctl enable mongodb --now

# 设置MySQL root密码并创建数据库
MYSQL_ROOT_PASSWORD="wvp123456"
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
CREATE DATABASE wvp CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
EOF

echo "MySQL 数据库创建成功，密码为: ${MYSQL_ROOT_PASSWORD}"

# 克隆并编译 ZLMediaKit
cd ~
git clone https://github.com/ZLMediaKit/ZLMediaKit.git
cd ZLMediaKit
mkdir -p release/linux/Release
cd release/linux/Release
cmake ../..
make -j$(nproc)

# 配置 ZLMediaKit 启动服务
cat <<EOF >/etc/systemd/system/zlmediakit.service
[Unit]
Description=ZLMediaKit Service
After=network.target

[Service]
ExecStart=/root/ZLMediaKit/release/linux/Release/MediaServer
WorkingDirectory=/root/ZLMediaKit/release/linux/Release/
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable zlmediakit --now

# 克隆并编译 WVP-PRO 后端
cd ~
git clone https://github.com/648540858/wvp-GB28181-pro.git wvp-pro
cd wvp-pro
mvn clean install -Dmaven.test.skip=true

# 修改配置文件 application.yml
cat <<EOF >src/main/resources/application.yml
server:
  port: 18080

media:
  id: 123456
  ip: ${WVP_IP}
  hookIp: ${WVP_IP}
  sdpIp: ${WVP_IP}
  stream-ip: ${WVP_IP}
  http-port: 80
  rtp:
    port-range: 30000,30500

redis:
  host: 127.0.0.1
  port: 6379

spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/wvp?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC
    username: root
    password: ${MYSQL_ROOT_PASSWORD}
    driver-class-name: com.mysql.cj.jdbc.Driver

  data:
    mongodb:
      uri: mongodb://127.0.0.1:27017/wvp
EOF

# 重新构建 JAR 包
mvn clean package -Dmaven.test.skip=true

# 设置 WVP 启动服务
cat <<EOF >/etc/systemd/system/wvp.service
[Unit]
Description=WVP-PRO GB28181 Service
After=network.target zlmediakit.service

[Service]
ExecStart=/usr/bin/java -jar /root/wvp-pro/target/wvp-pro-*.jar
WorkingDirectory=/root/wvp-pro
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wvp --now

echo "======== 部署完成，访问 http://${WVP_IP}:18080 查看 WVP 页面 ========"
