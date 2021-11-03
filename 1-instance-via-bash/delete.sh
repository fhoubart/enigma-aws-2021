#!/bin/sh

nbRes=1
while [ $nbRes -gt 0 ]; do
	nbRes=0
	for arn in $(aws resourcegroupstaggingapi get-resources --tag-filters Key=labkey,Values=lab1 --output text --query 'ResourceTagMappingList[].ResourceARN'); do
		nbRes=`expr $nbRes + 1`
		echo "Deleting $arn"
		resource_type=`echo $arn | sed -e 's|.*:\(.*\)/[^/]*$|\1|'` 
		resource_id=`echo $arn | sed -e 's|.*:.*/\([^/]*\)$|\1|'` 
		echo "Resource type: $resource_type, Resource id: $resource_id"
	
		case $resource_type in
		"vpc")
			aws ec2 delete-vpc --vpc-id $resource_id
			;;
		"subnet")
			aws ec2 delete-subnet --subnet-id $resource_id
			;;
		"internet-gateway")
			for vpc_id in `aws ec2 describe-internet-gateways --internet-gateway $resource_id --query 'InternetGateways[].Attachments[].[VpcId]' --output text`; do
				echo "Detach $resource_id from $vpc_id"
				aws ec2 detach-internet-gateway --internet-gateway-id $resource_id --vpc-id $vpc_id
			done
			aws ec2 delete-internet-gateway --internet-gateway-id $resource_id
			;;
		"route-table")
			aws ec2 delete-route-table --route-table-id $resource_id
			;;
		"instance")
			aws ec2 terminate-instances --instance-ids $resource_id
			;;
		"security-group")
			aws ec2 delete-security-group --group-id $resource_id
			;;
		*)
			echo "Je ne sais pas comment supprimer un $resource_type"
		esac
	done
done

