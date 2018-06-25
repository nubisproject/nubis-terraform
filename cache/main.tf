module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

resource "aws_elasticache_cluster" "cache" {
  cluster_id        = "${var.service_name}-${var.environment}"
  engine            = "memcached"
  node_type         = "${var.instance_type}"
  port              = 11211
  num_cache_nodes   = 1
  apply_immediately = true
  subnet_group_name = "${aws_elasticache_subnet_group.clients.name}"

  security_group_ids = [
    "${aws_security_group.clients.id}",
  ]

  tags = {
    Name           = "${var.service_name}-${var.environment}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}

resource "aws_elasticache_subnet_group" "clients" {
  name        = "${var.service_name}-${var.environment}-cache-subnetgroup"
  description = "Subnet Group for Cache ${var.service_name}-${var.environment}"

  subnet_ids = [
    "${split(",",module.info.private_subnets)}",
  ]
}

resource "aws_security_group" "clients" {
  vpc_id = "${module.info.vpc_id}"

  ingress {
    from_port = 11211
    to_port   = 11211
    protocol  = "tcp"

    security_groups = [
      "${split(",",var.client_security_groups)}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "${var.service_name}-${var.environment}-elasticache"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}
