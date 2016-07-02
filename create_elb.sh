#!/bin/bash


if [ -z $1 ]; then
    echo "$0 elbname"
    exit 1
fi

# Unique ELB Name
elbname=$1
# FULL ARN TO SSL CERT
sslcert=arn:aws:acm:REGION:ACCOUNTID:certificate/11111111-1111-1111-1111-111111111111
# ELB Security Group That Allows TCP 80 and TCP 443
securitygroup=sg-11111111
# Subnet ID For ELB
subnet=subnet-11111111
# AWS Region
region=us-east-1
# EC2 Instance ID
ec2instance=i-11111111111111111

# Create the ELB
aws elb create-load-balancer --load-balancer-name ${elbname} --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=8080" "Protocol=HTTPS,LoadBalancerPort=443,InstanceProtocol=HTTP,InstancePort=8080,SSLCertificateId=${sslcert}" --security-groups ${securitygroup} --subnets ${subnet} --region ${region}

# Configure the ELB Healthchecks
aws elb configure-health-check --load-balancer-name ${elbname} --health-check Target=HTTP:8080/healthcheck.html,Interval=15,UnhealthyThreshold=5,HealthyThreshold=2,Timeout=5 --region ${region}

# Register the EC2 Instance with the ELB
aws elb register-instances-with-load-balancer --load-balancer-name ${elbname} --instances ${ec2instance} --region ${region}

# Sleep 55 minutes (elbs are charged by the hour so get full hours worth of time)
sleep 3300

# Delete the ELB so you don't get charged for it
aws elb delete-load-balancer --load-balancer-name ${elbname} --region ${region}


