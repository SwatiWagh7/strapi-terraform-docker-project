variable "aws_region" {}
variable "environment" {}

variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}

variable "instance_type" {}
variable "key_name" {}

variable "strapi_port" {
  default = 1337
}
