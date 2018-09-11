module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

resource "aws_security_group" "load_balancer" {
  name_prefix = "${var.service_name}-${var.environment}-"

  vpc_id = "${module.info.vpc_id}"

  ingress {
    from_port   = "${var.port_http}"
    to_port     = "${var.port_http}"
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_cidrs}"
  }

  ingress {
    from_port   = "${var.port_https}"
    to_port     = "${var.port_https}"
    protocol    = "tcp"
    cidr_blocks = "${var.whitelist_cidrs}"
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

data "template_file" "ssl_cert_id" {
  # Last item is empty on purpose, for no_ssl_cert
  template = "$${ONE},$${TWO},"

  vars = {
    ONE = "arn:aws:iam::${module.info.account_id}:server-certificate/${var.region}.${var.account}.${var.nubis_domain}"
    TWO = "arn:aws:iam::${module.info.account_id}:server-certificate/${var.ssl_cert_name_prefix}-${var.environment}"
  }
}

resource "aws_elb" "load_balancer" {
  # XXX: 32-character limit needs fixing
  name = "${var.service_name}-${var.environment}"

  subnets = [
    "${split(",", module.info.public_subnets)}",
  ]

  security_groups = [
    "${module.info.internet_access_security_group}",
    "${module.info.shared_services_security_group}",
    "${aws_security_group.load_balancer.id}",
  ]

  listener {
    instance_port     = "${var.backend_port_http}"
    instance_protocol = "${var.backend_protocol}"
    lb_port           = "${var.port_http}"
    lb_protocol       = "${var.protocol_http}"
  }

  listener {
    instance_port      = "${var.backend_port_https}"
    instance_protocol  = "${var.backend_protocol}"
    lb_port            = "${var.port_https}"
    lb_protocol        = "${var.protocol_https}"
    ssl_certificate_id = "${element(split(",",data.template_file.ssl_cert_id.rendered),  ( signum(length(var.ssl_cert_name_prefix)) * ( 1 - signum(var.no_ssl_cert) ) ) + ( 2 * signum(var.no_ssl_cert) )  )}"
  }

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    target              = "${var.health_check_target}"
    interval            = 30
  }

  access_logs {
    bucket   = "${module.info.access_logging_bucket}"
    interval = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = true
  connection_draining_timeout = 60
  internal                    = "${var.internal}"

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
