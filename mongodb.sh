#!/bin/bash

USER_ID=$(id -u)
LOG_FOLDER="/var/log/scriptlog"
LOG_FILE="$LOG_FOLDER/$0.log"

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

cp mongo.repo  /etc/yum.repos.d/mongo.repo
valid $? "copying mongo repo"

dnf install mongodb-org -y 
valid $? "installing mongodb "

systemctl enable mongod 
systemctl start mongod 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
valid $? "allowing remote connection"
systemctl restart mongod