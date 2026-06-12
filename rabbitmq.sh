#!/bin/bash
CURRENT_DIR=$PWD
cp $CURRENT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
dnf install rabbitmq-server -y
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
systemctl daemon-reload
systemctl enable payment 
systemctl start payment
