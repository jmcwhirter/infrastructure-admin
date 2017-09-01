variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "chef-server" {
    default = "chef-server"
}

variable "chef-node" {
    default = "chef-node"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        chef-server = "ami-cd0f5cb6"
        chef-node = "ami-4fffc834"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}