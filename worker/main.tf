module "info" { 
  source = "../info"
  region = "${var.region}"
  environment = "${var.environment}"
  account = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "extra" {
  count = "${signum(length(var.security_group)) + 1 % 2}"

  vpc_id = "${module.info.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.service_name}-${var.environment}"
    Region      = "${var.region}"
    Environment = "${var.environment}"
  }

}

resource "aws_launch_configuration" "launch_config" {
  name_prefix = "${var.service_name}-${var.environment}-${var.region}-"

  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.ssh_key_name}"
    
  security_groups = [
    "${split(",", module.info.instance_security_groups)}",
    "${coalesce(aws_security_group.extra.*.id, var.security_group)}"
  ]
  user_data = "${template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }


}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.service_name}-${var.environment}-${var.region}-asg (LC ${aws_launch_configuration.launch_config.id})"
  desired_capacity          = "${var.desired_instances}"
  max_size                  = "${(var.desired_instances * 2) + 1}"
  min_size                  = "${var.min_instances}"
  launch_configuration      = "${aws_launch_configuration.launch_config.id}"

#  health_check_grace_period = "${var.hc_grace_period}"
#  health_check_type         = "EC2"
#  force_delete              = "${var.force_delete}"
   vpc_zone_identifier       = [
     "${split(",",module.info.private_subnets)}"
  ]
#  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

#  tag {
#    key                 = "Name"
#    value               = "Consul server node (${var.nubis_version}) for ${var.service_name} in ${element(split(",",var.environments), count.index)}"
#    propagate_at_launch = true
#  }

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "user_data" {
  template = <<EOF
NUBIS_ACCOUNT="${NUBIS_ACCOUNT}"
NUBIS_DOMAIN="${NUBIS_DOMAIN}"
NUBIS_ENVIRONMENT="${NUBIS_ENVIRONMENT}"
NUBIS_PROJECT="${NUBIS_PROJECT}"
NUBIS_PURPOSE="${NUBIS_PURPOSE}"
NUBIS_STACK=""
NUBIS_MIGRATE="1"
CONSUL_ACL_TOKEN="${CONSUL_ACL_TOKEN}"
ROLL=1
EOF
  vars {
    NUBIS_STACK= ""
    NUBIS_PROJECT= "${var.service_name}"
    NUBIS_MIGRATE= "1"
    CONSUL_ACL_TOKEN= "${var.consul_token}"
    NUBIS_PURPOSE= "${var.purpose}"
    NUBIS_ENVIRONMENT = "${var.environment}"
    NUBIS_DOMAIN = "${var.nubis_domain}"
    NUBIS_ACCOUNT = "${var.account}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
