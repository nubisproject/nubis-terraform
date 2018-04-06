module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "extra" {
  count = "${var.enabled * ( 1 + var.security_group_custom ) % 2}"

  name_prefix = "${var.service_name}-${var.environment}-${var.purpose}-"

  vpc_id = "${module.info.vpc_id}"

  tags = {
    Name           = "${var.service_name}-${var.environment}-${var.purpose}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    Arena          = "${var.arena}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${module.info.ssh_security_group}",
    ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "launch_config" {
  count       = "${var.enabled}"
  name_prefix = "${var.service_name}-${var.environment}-${var.region}-${var.purpose}-${local.az_index_identifier}"

  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${coalesce(var.ssh_key_name, "nubis")}"

  # IAM Role (can be empty)
  iam_instance_profile = "${coalesce(var.instance_profile, aws_iam_instance_profile.extra.name)}"

  associate_public_ip_address = "${var.public}"

  enable_monitoring = false

  # Default ones for all instances in the VPC
  # plus one more, just for us  
  security_groups = [
    "${split(",", module.info.instance_security_groups)}",
    "${compact(list(var.monitoring ? module.info.monitoring_security_group : "" )) }",
    "${split(",",element(compact(concat(list(var.security_group), aws_security_group.extra.*.id)), 0))}",
  ]

  user_data = "${data.template_file.user_data.rendered}"

  root_block_device = {
    volume_size           = "${var.root_storage_size}"
    volume_type           = "${var.root_storage_type}"
    delete_on_termination = true
  }

  ebs_block_device = "${local.data_volume[var.data_storage_size <= 0 ? 0 : 1]}"

  lifecycle {
    create_before_destroy = true
  }
}

# Default health-check depends on if var.elb is set
variable "health_check_type_map" {
  type = "map"

  default = {
    "0" = "EC2"
    "1" = "ELB"
  }
}

locals {
  vpc_zone_identifier = "${var.public ? module.info.public_subnets : module.info.private_subnets}"
  az_index_identifier = "${var.az_index < 0 ? "" : "az${var.az_index}-"}"
  data_volume         = "${list(list(), list(map("device_name", var.data_storage_device, "volume_size", var.data_storage_size, "volume_type", var.data_storage_type, "encrypted", var.storage_encrypted_at_rest)))}"
}

resource "aws_autoscaling_group" "asg" {
  count                = "${var.enabled}"
  name                 = "${var.service_name}-${var.environment}-${var.region}-${local.az_index_identifier}asg (${var.purpose}) (LC ${aws_launch_configuration.launch_config.id})"
  max_size             = "${coalesce(var.max_instances, 1 + (4*var.min_instances) )}"
  min_size             = "${var.min_instances}"
  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  health_check_grace_period = "${var.health_check_grace_period}"

  # Use the provided variable explicitely, otherwise, default depending on if we are using an ELB or not
  health_check_type = "${coalesce(var.health_check_type, lookup(var.health_check_type_map, signum(length(var.elb))))}"

  vpc_zone_identifier = [
    "${split(",", var.az_index >= 0 ? element(split(",",local.vpc_zone_identifier), abs(var.az_index) ) : local.vpc_zone_identifier)}",
  ]

  load_balancers = [
    "${compact(split(",",var.elb))}",
  ]

  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  # Only wait if health_check_type is ELB
  wait_for_elb_capacity = "${coalesce(var.health_check_type, lookup(var.health_check_type_map, signum(length(var.elb)))) == "ELB" ? var.min_instances : 0}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = ["${concat(
    list(
      map("key", "Name", "value", "${var.service_name} (${var.purpose}) (${coalesce(var.nubis_version, module.info.nubis_version)}) for ${var.account} in ${var.arena}/${var.environment}", "propagate_at_launch", true),
      map("key", "ServiceName", "value", "${var.service_name}", "propagate_at_launch", true),
      map("key", "Region", "value", "${var.region}", "propagate_at_launch", true),
      map("key", "Environment", "value", "${var.environment}", "propagate_at_launch", true),
      map("key", "Arena", "value", "${var.arena}", "propagate_at_launch", true),
      map("key", "TechnicalOwner", "value", "${var.technical_owner}", "propagate_at_launch", true),
      map("key", "Purpose", "value", "${var.purpose}", "propagate_at_launch", true),
      map("key", "Shutdown", "value", "never", "propagate_at_launch", true),
      map("key", "Backup", "value", "true", "propagate_at_launch", true),
    ),
    var.tags)
  }"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "extra" {
  # Create only if instance_profile isn't set
  count = "${var.enabled * (signum(length(var.instance_profile)) + 1 % 2)}"

  name = "${var.service_name}-${var.environment}-${var.region}-${var.purpose}-${local.az_index_identifier}profile"
  role = "${coalesce(var.role, aws_iam_role.extra.name)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "extra" {
  # Create only if instance_profile isn't set and role isn't set
  count = "${var.enabled * (signum(length(var.instance_profile)) + 1 % 2) * ( signum(length(var.role)) + 1 % 2 ) }"

  name = "${var.service_name}-${var.environment}-${var.region}-${var.purpose}-${local.az_index_identifier}role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  count    = "${var.enabled}"
  template = "${file("${path.module}/templates/userdata.tpl")}"

  vars {
    NUBIS_PROJECT       = "${var.service_name}"
    CONSUL_ACL_TOKEN    = "${var.consul_token}"
    NUBIS_PURPOSE       = "${var.purpose}"
    NUBIS_ENVIRONMENT   = "${var.environment}"
    NUBIS_ARENA         = "${var.arena}"
    NUBIS_DOMAIN        = "${var.nubis_domain}"
    NUBIS_ACCOUNT       = "${var.account}"
    NUBIS_STACK         = "${var.service_name}-${var.environment}"
    NUBIS_SUDO_GROUPS   = "${var.nubis_sudo_groups}"
    NUBIS_USER_GROUPS   = "${var.nubis_user_groups}"
    NUBIS_SWAP_SIZE_MEG = "${var.swap_size_meg}"
  }
}

resource "aws_autoscaling_policy" "up" {
  count                  = "${var.enabled * (signum(var.scale_load_defaults + signum(length(var.scale_up_load))))}"
  name                   = "${var.service_name}-${var.environment}-${var.purpose}-scaleup-asp"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_autoscaling_policy" "down" {
  count                  = "${var.enabled * (signum(var.scale_load_defaults + signum(length(var.scale_down_load))))}"
  name                   = "${var.service_name}-${var.environment}-${var.purpose}-scaledown-asp"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "up" {
  count               = "${var.enabled * (signum(var.scale_load_defaults + signum(length(var.scale_up_load))))}"
  alarm_name          = "${var.service_name}-${var.environment}-${var.purpose}-scaleup-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "${coalesce(var.scale_up_load,50)}"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "down" {
  count               = "${var.enabled * (signum(var.scale_load_defaults + signum(length(var.scale_down_load))))}"
  alarm_name          = "${var.service_name}-${var.environment}-${var.purpose}-scaledown-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "${coalesce(var.scale_down_load,20)}"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
  }

  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.down.arn}"]
}

resource "aws_key_pair" "ssh" {
  count      = "${var.enabled * (signum(length(var.ssh_key_file)))}"
  public_key = "${file(var.ssh_key_file)}"
  key_name   = "${var.ssh_key_name}"
}
