provider "aws" {
  region = "ap-northeast-2"
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

### 백업용 S3 및 dynamodb
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "TerraformStateLock"
  read_capacity  = 5
  write_capacity = 5
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

  lifecycle {
    prevent_destroy = true
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
variable "ecs_aws_ami" {}

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
