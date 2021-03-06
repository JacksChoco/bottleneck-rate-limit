module "vpc" {
  source = "../vpc"

  cidr        = "${var.vpc_cidr}"
  environment = "${var.environment}"
}

module "public_subnet" {
  source = "../subnet"

  name               = "${var.environment}_public_subnet"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  cidrs              = "${var.public_subnet_cidrs}"
  availability_zones = "${var.availability_zones}"
}

module "nlb" {
  source = "../nlb"

  nlb_name          = "${var.environment}-ecs-nlb"
  environment       = "${var.environment}"
  vpc_id            = "${module.vpc.id}"
  public_subnet_ids = "${module.public_subnet.ids}"
}

module "security_group" {
  source = "../security_group"

  name                     = "${var.environment}_security_group"
  environment              = "${var.environment}"
  vpc_id                   = "${module.vpc.id}"
  source_security_group_id = "${module.nlb.nlb_security_group_id}"
}

resource "aws_route" "public_igw_route" {
  count                  = "${length(var.public_subnet_cidrs)}"
  route_table_id         = "${element(module.public_subnet.route_table_ids, count.index)}"
  gateway_id             = "${module.vpc.igw}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

# module "private_subnet" {
#   source = "../subnet"


#   name               = "${var.environment}_private_subnet"
#   environment        = "${var.environment}"
#   vpc_id             = "${module.vpc.id}"
#   cidrs              = "${var.private_subnet_cidrs}"
#   availability_zones = "${var.availability_zones}"
# }


# module "nat" {
#   source = "../nat_gateway"


#   subnet_ids   = "${module.public_subnet.ids}"
#   subnet_count = "${length(var.public_subnet_cidrs)}"
# }


# resource "aws_route" "private_nat_route" {
#   count                  = "${length(var.private_subnet_cidrs)}"
#   route_table_id         = "${element(module.private_subnet.route_table_ids, count.index)}"
#   nat_gateway_id         = "${element(module.nat.ids, count.index)}"
#   destination_cidr_block = "${var.destination_cidr_block}"
# }


# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding.
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished.
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534


# resource "null_resource" "dummy_dependency" {
#   depends_on = ["module.nat"]
# }

