#!/bin/bash

VPC_CIDR=10.3.0.0/24
SUBNET_CIDR=10.3.0.0/24
TAGS=Tags=[{Key=labkey,Value=lab1}]

# Creation du VPC
vpc_id=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --tag-specifications ResourceType=vpc,$TAGS | jq -r '.Vpc.VpcId')
echo "VPC id: $vpc_id"


# Creation du subnet
subnet_id=$(aws ec2 create-subnet --cidr-block $SUBNET_CIDR --vpc-id $vpc_id --tag-specifications ResourceType=subnet,$TAGS | jq -r '.Subnet.SubnetId')
echo "Subnet id: $subnet_id"

# Creation de l'internet gateway
ig_id=$(aws ec2 create-internet-gateway --tag-specifications ResourceType=internet-gateway,$TAGS | jq -r '.InternetGateway.InternetGatewayId')
echo "Internet Gatewat id: $ig_id"

# Attache internet gateway
aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $ig_id

# Creation de la route
rt_id=$(aws ec2 create-route-table --vpc-id $vpc_id --tag-specifications ResourceType=route-table,$TAGS | jq -r '.RouteTable.RouteTableId')
echo "Route table id: $rt_id"

aws ec2 create-route --route-table-id $rt_id --destination-cidr-block 0.0.0.0/0 --gateway-id $ig_id

aws ec2 associate-route-table --route-table-id $rt_id --subnet-id $subnet_id

sg_id=$(aws ec2 create-security-group --group-name 'SG' --description 'Multiusage security group' --vpc-id $vpc_id --tag-specifications ResourceType=security-group,$TAGS | jq -r '.GroupId')
echo "Security Group id: $sg_id"

aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 80 --cidr 0.0.0.0/0

#aws ec2 create-key-pair --key-name test --tag-specifications ResourceType=key-pair,group,$TAGS
