variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "shared_config_files" {
  type    = list(any)
  default = ["~/.aws/config"]
}

variable "shared_credentials_files" {
  type    = list(any)
  default = ["~/.aws/credentials"]
}

variable "profile" {
  type    = string
  default = "default"
}

variable "vpc_cidr" {
  type    = string
  default = "10.11.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "tf-managed-vpc"
}

variable "subnet_cidr" {
  type    = string
  default = "10.11.1.0/24"
}

variable "subnet_name" {
  type    = string
  default = "tf-managed-subnet-public"
}

variable "internet_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ubuntu_ami" {
  type    = string
  default = "ami-0333305f9719618c7"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "default"

}

variable "s3_backend_bucket" {
  type    = string
  default = "huzaifa-tf-backend"
}

variable "s3_key" {
  type    = string
  default = "dev/terraform.tfstate"

}
