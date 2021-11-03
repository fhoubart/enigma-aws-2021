#!/bin/sh

TAGS=Tags=[{Key=labkey,Value=lab1}]

echo $subnet_id


resultat=$(aws ec2 describe-instances --filter Name=tag:labkey,Values=lab1 --output text --query 'Reservations[].Instances[].[InstanceId,State.Name]')



function creation() {
	subnet_id=$(aws ec2 describe-subnets --filter Name=tag:labkey,Values=lab1 --query 'Subnets[].SubnetId' --output text)
	sg_id=$(aws ec2 describe-security-groups --filter Name=tag:labkey,Values=lab1 --query 'SecurityGroups[].GroupId' --output text)
	aws ec2 run-instances --image-id ami-0da7ba92c3c072475 --count 1 --instance-type t2.micro --key-name lab-keypair --security-group-ids $sg_id --subnet-id $subnet_id --tag-specifications ResourceType=instance,$TAGS
}

function redemarrage() {
	echo "L'instance $1 est a l'etat $2"
	aws ec2 start-instances --instance-ids $1
}

# Cas ou l'instance n'existe pas
if [ -z "$resultat" ]; then
	creation	
else
	instance_id=`echo $resultat | cut -d" " -f1`
	state=`echo $resultat | cut -d" " -f2`

	echo $instance_id
	echo $state

	case $state in
	"terminated")
		creation
		;;
	"stopped")
		redemarrage $instance_id $state
		;;
	"stopping")
		redemarrage $instance_id $state
		;;
	"shutting-down")
		redemarrage $instance_id $state
		;;
	*)
		echo "Tout va bien l'instance $instance_id est $state"
		;;
	esac
fi

	




