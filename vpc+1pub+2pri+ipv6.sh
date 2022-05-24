#!/bin/bash


# Creating VPC 
VPC_ID = $(aws ec2 create-vpc --cidr-block 10.10.0.0/16 --amazon-provided-ipv6-cidr-block --query Vpc.VpcId.Value)

# Creating Subnets
aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.10.0.0/24 --ipv6-cidr-block 2a05:d018:1d4c:9600::/64
aws ec2 create-subnet --vpc-id vpc-0876b22c242af3ab2 --cidr-block 10.10.1.0/24 --ipv6-cidr-block 2a05:d018:1d4c:9601::/64
aws ec2 create-subnet --vpc-id vpc-0876b22c242af3ab2 --cidr-block 10.10.2.0/24 --ipv6-cidr-block 2a05:d018:1d4c:9602::/64

# Creating and attaching IGW
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --internet-gateway-id igw-06751ad391186e74d --vpc-id vpc-0876b22c242af3ab2

# Creating routes, route tables and associating route tables
aws ec2 create-route --route-table-id rtb-0ecdfbe215b15eece --destination-ipv6-cidr-block ::/0 --gateway-id igw-06751ad391186e74d
aws ec2 create-route --route-table-id rtb-0ecdfbe215b15eece --destination-cidr-block 0.0.0.0/0 --gateway-id igw-06751ad391186e74d
aws ec2 associate-route-table --subnet-id subnet-030777892113d6acd --route-table-id rtb-0ecdfbe215b15eece
aws ec2 create-egress-only-internet-gateway --vpc-id vpc-0876b22c242af3ab2
aws ec2 create-route-table --vpc-id vpc-0876b22c242af3ab2
aws ec2 create-route --route-table-id rtb-0bde9def85394c08e --destination-ipv6-cidr-block ::/0 --egress-only-internet-gateway-id eigw-0236d9983ddab1d86
aws ec2 associate-route-table --subnet-id subnet-00a96f9f9bea0bc81 --route-table-id rtb-0bde9def85394c08e
aws ec2 associate-route-table --subnet-id subnet-0336b0e1bfd66be6b --route-table-id rtb-0bde9def85394c08e
aws ec2 modify-subnet-attribute --subnet-id subnet-0336b0e1bfd66be6b --assign-ipv6-address-on-creation
aws ec2 modify-subnet-attribute --subnet-id subnet-00a96f9f9bea0bc81 --assign-ipv6-address-on-creation