#!/bin/bash

USER_ID=$(id -u)
dnf install mysql-server -y
systemctl enable mysqld
systemctl start mysqld  
mysql_secure_installation --set-root-pass RoboShop@1