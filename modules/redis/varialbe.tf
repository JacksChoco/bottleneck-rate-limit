variable "environment" {}
variable "vpc_id" {}
variable "source_security_group_id" {}

variable "subnet_ids" {
  type = "list"
}
