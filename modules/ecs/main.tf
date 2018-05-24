resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.environment}-cluster"
}

resource "aws_autoscaling_group" "ecs_cluster_instances" {
  name             = "${var.environment}-cluster-instances"
  min_size         = "${var.min_size}"
  max_size         = "${var.max_size}"
  desired_capacity = "${var.min_size}"
  force_delete     = true

  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]

  target_group_arns = ["${var.target_group_arns}"]
}

resource "aws_launch_configuration" "ecs_instance" {
  name_prefix = "ecs-instance-"

  // name            = "${var.environment}-instance"
  image_id                    = "${data.aws_ami.stable_coreos.id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${var.security_group_id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.app.name}"
  user_data                   = "${data.template_file.cloud_config.rendered}"
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    aws_region         = "${var.region}"
    ecs_cluster_name   = "${aws_ecs_cluster.ecs_cluster.name}"
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  }
}

data "aws_ami" "stable_coreos" {
  most_recent = true

  filter {
    name   = "description"
    values = ["CoreOS Container Linux stable *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] # CoreOS
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.environment}-cluster-group/ecs-agent"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${var.environment}-cluster-group/app-ghost"
}
