#!/bin/sh

TAGS=Tags=[{Key=labkey,Value=lab1}]

echo $subnet_id


subnet_id=$(aws ec2 describe-subnets --filter Name=tag:labkey,Values=lab1 --query 'Subnets[].SubnetId' --output text)
sg_id=$(aws ec2 describe-security-groups --filter Name=tag:labkey,Values=lab1 --query 'SecurityGroups[].GroupId' --output text)
aws ec2 run-instances --associate-public-ip-address --image-id ami-0da7ba92c3c072475 --count 1 --instance-type t2.micro --key-name lab-keypair --security-group-ids $sg_id --subnet-id $subnet_id --tag-specifications ResourceType=instance,$TAGS --user-data file://user-data.sh