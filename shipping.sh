#!/bin/bash
CURRENT_DIR=$PWD
dnf install maven -y
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
mkdir /app 
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
cd /app 
unzip /tmp/shipping.zip
mvn clean package 
mv target/shipping-1.0.jar shipping.jar 
cp $CURRENT_DIR/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping 
systemctl start shipping
dnf install mysql -y 
mysql -h mysql.yashwanthaarem.in -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql.yashwanthaarem.in -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql.yashwanthaarem.in -uroot -pRoboShop@1 < /app/db/master-data.sql
systemctl restart shipping