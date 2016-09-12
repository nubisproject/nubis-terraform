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
  count = "${signum(length(var.security_group)) + 1 % 2}"

  vpc_id = "${module.info.vpc_id}"

  tags = {
    Name           = "${var.service_name}-${var.environment}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "monitoring" {
  template = "${ONE},${TWO}"

  vars = {
    ONE = "${coalesce(aws_security_group.extra.id, var.security_group)}"
    TWO = "${module.info.monitoring_security_group}"
  }
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix = "${var.service_name}-${var.environment}-${var.region}-"

  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.ssh_key_name}"

  # IAM Role (can be empty)
  iam_instance_profile = "${coalesce(var.instance_profile, aws_iam_instance_profile.extra.name)}"

  # Default ones for all instances in the VPC
  # plus one more, just for us  
  security_groups = [
    "${split(",", module.info.instance_security_groups)}",
    "${coalesce(aws_security_group.extra.id, var.security_group)}",
    "${element(split(",",template_file.monitoring.rendered), var.monitoring)}",
  ]

  user_data = "${template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

# Careful, must also edit asg_elb in sync with this one, unfortunately

resource "aws_autoscaling_group" "asg" {
  # Create only if elb isn't set
  count                = "${signum(length(var.elb)) + 1 % 2}"
  name                 = "${var.service_name}-${var.environment}-${var.region}-asg (LC ${aws_launch_configuration.launch_config.id})"
  desired_capacity     = "${var.desired_instances}"
  max_size             = "${(var.desired_instances * 2) + 1}"
  min_size             = "${var.min_instances}"
  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${coalesce(var.health_check_type, "EC2")}"

  vpc_zone_identifier = [
    "${split(",",module.info.private_subnets)}",
  ]

  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  tag {
    key                 = "Name"
    value               = "${var.service_name} (${coalesce(var.nubis_version, module.info.nubis_version)}) for ${var.account} in ${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "ServiceName"
    value               = "${var.service_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "TechnicalOwner"
    value               = "${var.technical_owner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Shutdown"
    value               = "never"
    propagate_at_launch = true
  }

  tag {
    key                 = "Backup"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# XXX: Careful, must be mainly identical to the asg above
resource "aws_autoscaling_group" "asg_elb" {
  # create if elb is set
  count                = "${signum(length(var.elb)) % 2}"
  name                 = "${var.service_name}-${var.environment}-${var.region}-asg (LC ${aws_launch_configuration.launch_config.id})"
  desired_capacity     = "${var.desired_instances}"
  max_size             = "${(var.desired_instances * 2) + 1}"
  min_size             = "${var.min_instances}"
  launch_configuration = "${aws_launch_configuration.launch_config.id}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${coalesce(var.health_check_type, "EC2")}"

  vpc_zone_identifier = [
    "${split(",",module.info.private_subnets)}",
  ]

  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  load_balancers = [
    "${var.elb}",
  ]

  tag {
    key                 = "Name"
    value               = "${var.service_name} (${coalesce(var.nubis_version, module.info.nubis_version)}) for ${var.account} in ${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "ServiceName"
    value               = "${var.service_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Region"
    value               = "${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "TechnicalOwner"
    value               = "${var.technical_owner}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Shutdown"
    value               = "never"
    propagate_at_launch = true
  }

  tag {
    key                 = "Backup"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "extra" {
  # Create only if instance_profile isn't set
  count = "${signum(length(var.instance_profile)) + 1 % 2}"

  name  = "${var.service_name}-${var.environment}-${var.region}-profile"
  roles = ["${coalesce(var.role, aws_iam_role.extra.name)}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "extra" {
  # Create only if instance_profile isn't set and role isn't set
  count = "${(signum(length(var.instance_profile)) + 1 % 2) * ( signum(length(var.role)) + 1 % 2 ) }"

  name = "${var.service_name}-${var.environment}-${var.region}-role"

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

resource "template_file" "user_data" {
  template = "${file("${path.module}/templates/userdata.tpl")}"

  vars {
    NUBIS_STACK       = ""
    NUBIS_PROJECT     = "${var.service_name}"
    NUBIS_MIGRATE     = "1"
    CONSUL_ACL_TOKEN  = "${var.consul_token}"
    NUBIS_PURPOSE     = "${var.purpose}"
    NUBIS_ENVIRONMENT = "${var.environment}"
    NUBIS_DOMAIN      = "${var.nubis_domain}"
    NUBIS_ACCOUNT     = "${var.account}"
    NUBIS_MIGRATE     = "${var.migrate}"
    NUBIS_STACK       = "${var.service_name}-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
