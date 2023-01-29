terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

    backend "s3" {
    bucket = "my-test-123"
    key = "terraformstate.tfstate"
    region = "eu-west-1"
    shared_credentials_file = "~/.aws/credentials"
    profile = "default"
    
  }
}

provider "aws" {
  region                   = var.region
  shared_config_files      = var.shared_config_files
  shared_credentials_files = var.shared_credentials_files
  profile                  = var.profile
}

resource "aws_vpc" "tf-vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = false
  enable_dns_support   = false

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "tf-igw" {

  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    "Name" = "tf-managed-igw"
  }
}

resource "aws_subnet" "tf-pub-subnet" {

  cidr_block = var.subnet_cidr
  vpc_id     = aws_vpc.tf-vpc.id

  tags = {
    "Name" = var.subnet_name
  }
}

resource "aws_route_table" "tf-rt-pub" {

  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = var.internet_cidr
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    "Name" = "tf-rt-pub"
  }
}

resource "aws_route_table_association" "tf-rt-pub-assoc-pub-subnet" {
  route_table_id = aws_route_table.tf-rt-pub.id
  subnet_id      = aws_subnet.tf-pub-subnet.id
}

resource "aws_security_group" "tf-sg-pub" {

  name        = "tf-managed-sg-pub"
  description = "TF managed public SG"

  vpc_id = aws_vpc.tf-vpc.id

  ingress {
    description = "Rule for allowing SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["82.20.148.238/32"]
  }

  egress {
    description = "Rule for allowing all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "tf-sg-pub"
  }

}

resource "aws_instance" "tf-ec2" {

  ami = var.ubuntu_ami

  instance_type = var.instance_type

  subnet_id = aws_subnet.tf-pub-subnet.id


  #security_groups = [ "${aws_security_group.tf-sg-pub.id}" ]

  tags = {
    "Name" = "tf-managed-ec2"
  }
}

# resource "aws_iam_policy" "stop_start_ec2_policy" {
#   name = "StopStartEC2Policy"
#   path = "/"
#   description = "IAM policy for stop and start EC2 from a lambda"
# policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:Start*",
#         "ec2:Stop*",
#         "ec2:DescribeInstances*"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role" "stop_start_ec2_role" {
#   name = "StopStartEC2Role"
# assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }
# resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
#   role = "${aws_iam_role.stop_start_ec2_role.name}"
#   policy_arn = "${aws_iam_policy.stop_start_ec2_policy.arn}"
# }

# resource "aws_lambda_function" "stop_ec2_lambda" {
#   filename      = "my_lambda.zip"
#   function_name = "stopEC2Lambda"
#   role          = "${aws_iam_role.stop_start_ec2_role.arn}"
#   handler       = "startstopec2.stop"
#   source_code_hash = "${filebase64sha256("my_lambda.zip")}"
#   runtime = "python3.7"
#   memory_size = "250"
#   timeout = "60"
# }

# # resource "null_resource" "reboo_instance" {

# #   provisioner "local-exec" {
# #     on_failure  = "fail"
# #     interpreter = ["/bin/bash", "-c"]
# #     command     = <<EOT
# #         echo -e "\x1B[31m Warning! Stopping instance having id ${aws_instance.tf-ec2.id}.................. \x1B[0m"
# #         # To stop instance
# #         aws ec2 start-instances --instance-ids ${aws_instance.tf-ec2.id} --profile terraform
# #         echo "***************************************Rebooted****************************************************"
# #      EOT
# #   }
# # #   this setting will trigger script every time,change it something needed
# #   triggers = {
# #     always_run = "${timestamp()}"
# #   }


# # }

# resource "aws_cloudwatch_event_rule" "ec2_stop_rule" {
#   name        = "StopEC2Instances"
#   description = "Stop EC2 nodes at 13:25 from Monday to friday"
#   schedule_expression = "cron(50 13 ? * * *)"
# }
# resource "aws_cloudwatch_event_target" "ec2_stop_rule_target" {
#   rule      = "${aws_cloudwatch_event_rule.ec2_stop_rule.name}"
#   arn       = "${aws_lambda_function.stop_ec2_lambda.arn}"
# }

# resource "aws_lambda_permission" "allow_cloudwatch_stop" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.stop_ec2_lambda.function_name}"
#   principal     = "events.amazonaws.com"
# }


