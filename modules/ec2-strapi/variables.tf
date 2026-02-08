variable "environment" {}
variable "instance_type" {}
variable "key_name" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "nat_dependency" {
  description = "Dependency to ensure NAT is ready before EC2 launch"
  type        = any
}
