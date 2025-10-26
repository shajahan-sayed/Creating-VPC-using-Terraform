variable "aws_region" {
  description = "creating AWS region"
  type = string
  default = "ap-south-1"
}
variable "vpc_cidr" {
  description = "creationg CIDR block for VPC"
  type =  string
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "Creating CIDR block for public subnet"
  type = string
  default = "10.0.1.0/26"
}
variable "private_subnet_cidr" {
  description = "creating CIDR block for private subnet"
  type = string
  default = "10.0.2.0/24"
}
variable "key_name" {
  description = "creating key name"
  type = string
}
variable "instance_type" {
  description = "creating instance type"
  type = string
  default = "t2.micro"
}
variable "ami_id" {
  description = "creating ami id "
  type = string
}
