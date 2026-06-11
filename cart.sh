#!/bin/bash
CURRENT=$PWD
DOMAIN_NAME=redis.yashwanthaarem.in
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
mkdir /app 
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip
cd /app 
unzip /tmp/cart.zip
npm install 
cp $CURRENT/cart.service  /etc/systemd/system/cart.service

systemctl daemon-reload
systemctl enable cart 
systemctl start cart