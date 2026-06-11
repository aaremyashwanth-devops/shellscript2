#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER="/var/log/scriptlog"
LOG_FILE="$LOG_FOLDER/$0.log"
CURRENT=$PWD
DOMAIN_NAME="mongodb.yashwanthaarem.in"
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
N='\033[0m'

mkdir -p $LOG_FOLDER


if [ $USER_ID -ne 0 ]; then
    echo "switch to root user" 
    exit 1
fi
valid(){
    if [ $1 -ne 0 ]; then
        echo "$2...not installed" 
    else
        echo "$2....installed" 
    fi
}
dnf module disable nodejs  -y
dnf module enable nodejs:20 -y
dnf install nodejs -y
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
mkdir /app 
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
cd /app 
unzip /tmp/catalogue.zip
npm install 

cp $CURRENT/catalogue.service  /etc/systemd/system/catalogue.service
systemctl daemon-reload

systemctl enable catalogue 
systemctl start catalogue
cp $CURRENT/mongo.repo  /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y
mongosh --host $DOMAIN_NAME </app/db/master-data.js