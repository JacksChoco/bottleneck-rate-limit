variable "environment" {
  description = "The name of the environment"
}

variable "max_size" {
  description = "ec2 instance max size"
}

variable "min_size" {
  description = "ec2 instance min size"
}

variable "image_id" {
  description = "ec2 instance image id"
}

variable "instance_type" {
  description = "ec2 instance type"
}

variable "subnet_ids" {
  description = "ec2 lanuch subnet"
  type        = "list"
}

variable "target_group_arns" {
  description = "target_group_arns"
}

variable "security_group_id" {}

variable "region" {
  default = "ap-northeast-2"
}
