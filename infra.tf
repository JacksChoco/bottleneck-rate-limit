provider "aws" {
  region = "${var.region}"
}

module "network" {
  source               = "modules/network"
  environment          = "${var.environment}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  depends_id           = ""
}

module "ecr" {
  source      = "modules/ecr"
  environment = "${var.environment}"
}

# module "ecs" {
#   source = "modules/ecs"

#   region            = "${var.region}"
#   environment       = "${var.environment}"
#   max_size          = "${var.max_size}"
#   min_size          = "${var.min_size}"
#   image_id          = "${var.image_id}"
#   instance_type     = "${var.instance_type}"
#   target_group_arns = "${module.network.default_alb_target_group}"
#   security_group_id = "${module.network.security_group_id}"
#   subnet_ids        = "${module.network.public_subnet_ids}"
# }

### 백업용 S3 및 dynamodb
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "TerraformStateLock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// 로그 저장용 버킷
resource "aws_s3_bucket" "logs" {
  bucket = "kr.ne.outsider.logs"
  acl    = "log-delivery-write"
}

// Terraform state 저장용 S3 버킷
resource "aws_s3_bucket" "terraform-state" {
  bucket = "kr.ne.outsider.terraform.state"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name = "terraform state"
  }

  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }
}

terraform {
  required_version = ">= 0.9.5"

  backend "s3" {
    bucket     = "kr.ne.outsider.terraform.state"
    key        = "test/terraform.tfstate"
    region     = "ap-northeast-2"
    encrypt    = true
    lock_table = "TerraformStateLock"
    acl        = "bucket-owner-full-control"
  }
}

variable "vpc_cidr" {}
variable "environment" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "instance_type" {}
variable "image_id" {}

variable "region" {
  default = "ap-northeast-2"
}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.network.vpc_cidr}"
}

output "public_subnet_ids" {
  value = "${module.network.public_subnet_ids}"
}

output "security_group_id" {
  value = "${module.network.security_group_id}"
}

output "default_alb_target_group" {
  value = "${module.network.default_alb_target_group}"
}

output "ecr_url" {
  value = "${module.ecr.ecr_url}"
}
