# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have the name containing the name of the:
# environment, cluster name en the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

resource "aws_security_group" "instance" {
  name        = "${var.name}"
  description = "Used in ${var.environment}"
  vpc_id      = "${var.vpc_id}"
}

# We separate the rules from the aws_security_group because then we can manipulate the
# aws_security_group outside of this module
resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "inbound_internet_access" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${var.source_security_group_id}"
  security_group_id        = "${aws_security_group.instance.id}"
}
