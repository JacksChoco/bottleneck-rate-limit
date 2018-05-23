variable "name" {
  description = "Name of the subnet, actual name will be, for example: name_eu-west-1a"
}

variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "VPC id to place to subnet into"
}

variable "source_security_group_id" {
  description = "source의 보안그룹 ID"
}
