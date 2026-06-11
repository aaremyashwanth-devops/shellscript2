#!/bin/bash
CURRENT=$PWD
DOMAIN_NAME=redis.yashwanthaarem.in
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
mkdir /app 
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip 
cd /app 
unzip /tmp/user.zip
npm install 
cp $CURRENT/user.service  /etc/systemd/system/user.service

systemctl daemon-reload
systemctl enable user 
systemctl start user