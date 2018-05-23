output "vpc_id" {
  value = "${module.vpc.id}"
}

output "vpc_cidr" {
  value = "${module.vpc.cidr_block}"
}

# output "private_subnet_ids" {
#   value = "${module.private_subnet.ids}"
# }

output "public_subnet_ids" {
  value = "${module.public_subnet.ids}"
}

output "security_group_id" {
  value = "${module.security_group.security_group_id}"
}

output "default_alb_target_group" {
  value = "${module.alb.default_alb_target_group}"
}

output "ecr_url" {
  value = "${module.ecr.ecr_url}"
}

# output "depends_id" {
#   value = "${null_resource.dummy_dependency.id}"
# }

