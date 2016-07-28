variable "aws_access_key" {
  default = "ACCESS"
}

variable "aws_secret_access_key" {
  default = "SECRET"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "owner" {
  default = "jan.szalkowski"
}

variable "project" {
  default = "sbry-test"
}

variable "environment" {
  default = "dev"
}

variable "costcentre" {
  default = "666"
}

variable "role_app" {
  default = "go"
}

variable "role_web" {
  default = "lb"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "external_access_cidr_block" {
  default = "0.0.0.0/0"
}

variable "public_subnet_cidr_blocks" {
  default = "10.0.0.0/24,10.0.2.0/24"
}

variable "private_subnet_cidr_blocks" {
  default = "10.0.1.0/24,10.0.3.0/24"
}

variable "availability_zones" {
  default = "eu-west-1a,eu-west-1b"
}

variable "wide_open" {
  default = "0.0.0.0/0"
}

#Instance
#Ubuntu 16.4 hvm x64
variable "ami_id" {
  default = {
    ap-northeast-1 = "ami-23b54e42"
    ap-southeast-1 = "ami-e3974880"
    eu-central-1   = "ami-cbee1aa4"
    eu-west-1      = "ami-1967056a"
    sa-east-1      = "ami-d7d146bb"
    us-east-1      = "ami-cf68e0d8"
    us-west-1      = "ami-e59bda85"
    cn-north-1     = "ami-2c3bf141"
    us-gov-west-1  = "ami-565de337"
    ap-southeast-2 = "ami-6885af0b"
    us-west-2      = "ami-191fd379"
  }
}

variable "instance_type" {
  default = "t2.nano"
}

variable "aws_key_path" {
  default = "~/.ssh/sbry.pub"
}

variable "aws_key_name" {
  description = "Desired name of AWS key pair"
  default     = "whatever2"
}

#Autoscaling
variable "amax" {
  default = "4"
}

variable "amin" {
  default = "2"
}

variable "adesired" {
  default = "2"
}
