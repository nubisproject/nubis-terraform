module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "load_balancer" {
  vpc_id = "${module.info.vpc_id}"

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

resource "template_file" "ssl_cert_id" {
  template = "${ONE},${TWO}"

  vars = {
    ONE = "arn:aws:iam::${module.info.account_id}:server-certificate/${var.region}.${var.account}.${var.nubis_domain}"
    TWO = "arn:aws:iam::${module.info.account_id}:server-certificate/${var.ssl_cert_name_prefix}-${var.environment}"
  }
}

resource "aws_elb" "load_balancer" {
  # XXX: 32-character limit needs fixing
  name = "${var.service_name}-${var.environment}-${var.region}-elb"

  subnets = [
    "${split(",", module.info.public_subnets)}",
  ]

  security_groups = [
    "${module.info.internet_access_security_group}",
    "${module.info.shared_services_security_group}",
    "${aws_security_group.load_balancer.id}",
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${element(split(",",template_file.ssl_cert_id.rendered), signum(length(var.ssl_cert_name_prefix)))}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.health_check_target}"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

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
