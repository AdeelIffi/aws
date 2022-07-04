terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
    region  = "eu-west-2"
    shared_config_files = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "terraform"

}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.11.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "my-vpc-igw" {
    vpc_id = aws_vpc.my-vpc.id
}

resource "aws_subnet" "my-vpc-subnet" {

    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.11.1.0/24"
}

# resource "aws_instance" "my-vpc-ec2-instance" {

#     ami = "ami-0a5318a691549cd2b"

#     instance_type = "t3.micro"
  
# }