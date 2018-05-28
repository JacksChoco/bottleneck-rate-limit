output "nlb_security_group_id" {
  value = "${aws_security_group.nlb.id}"
}

output "default_nlb_target_group" {
  value = "${aws_lb_target_group.nlb.arn}"
}
