#!/bin/bash
LOG_FOLDER=var/log/scriptlog
LOG_FILE=var/log/scriptlog/$0.log

IAM_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-0728b5b2ef09a4522"
DOMAIN_NAME="yashwanthaarem.in"
HOSTED_ID="Z04906112GOBVOQ8X0E9B"

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
N='\033[0m'

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
    echo "switch to root user $R" $>>$LOG_FILE
    exit 1
fi
valid(){
    if [ $1 -ne 0 ]; then
        echo "not installed" $>>$LOG_FILE
    else
        echo "installed" $>>$LOG_FILE
    fi
}

for instance in $@
do
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $IAM_ID \
    --count 1 \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[*].InstanceId' \
    --output text)

    if [ $instance -ne frontend ];then
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' \
        --output text)
        RECORD_NAME=$instance.$DOMAIN_NAME
    else
        IP=$(aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text)
        RECORD_NAME=$DOMAIN_NAME
    fi
    echo "ipaddress:$IP"
    aws route53 change-resource-record-sets \
    --hosted-zone-id Z0123456789ABCDEF \
    --change-batch '{
        "Changes": [{
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "$RECORD_NAME",
                "Type": "A",
                "TTL": 1,
                "ResourceRecords": [{"Value": "$IP"}]
            }
        }]
    }'

echo "record updated for $instances"


done

