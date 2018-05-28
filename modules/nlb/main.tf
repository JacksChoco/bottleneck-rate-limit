resource "aws_lb" "nlb" {
  load_balancer_type         = "network"
  internal                   = false
  subnets                    = ["${var.public_subnet_ids}"]
  enable_deletion_protection = false

  // security_groups            = ["${aws_security_group.nlb.id}"]
}

resource "aws_lb_target_group" "nlb" {
  port        = 80
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
}

# resource "aws_lb_target_group_attachment" "nlb" {
#   availability_zone = "all"
#   target_group_arn  = "${aws_lb_target_group.nlb.arn}"
#   target_id         = "${var.host}"
#   port              = 80
# }

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = "${aws_lb.nlb.arn}"
  port              = 80
  protocol          = "TCP"

  "default_action" {
    target_group_arn = "${aws_lb_target_group.nlb.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "nlb" {
  name   = "${var.nlb_name}_nlb"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.nlb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.nlb.id}"
}
