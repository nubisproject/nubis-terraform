module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

# Discover Consul settings
module "consul" {
  source       = "../consul"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_efs_file_system" "storage" {
  tags = {
    Name           = "${var.service_name}-${var.environment}-storage"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}

resource "aws_efs_mount_target" "storage" {
  # XXX: subnets-per-vpc-count hard-coded
  count = "3"

  file_system_id = "${aws_efs_file_system.storage.id}"
  subnet_id      = "${element(split(",", module.info.private_subnets), count.index)}"

  security_groups = [
    "${aws_security_group.storage.id}",
  ]
}

resource "aws_security_group" "storage" {
  vpc_id = "${module.info.vpc_id}"

  tags = {
    Name           = "${var.service_name}-${var.environment}-efs"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }

  ingress {
    from_port = 2049
    to_port   = 2049
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
}

resource "consul_keys" "config" {
  key {
    name   = "fsid"
    path   = "${module.consul.config_prefix}/storage/${coalesce(var.storage_name,var.service_name)}/fsid"
    value  = "${aws_efs_file_system.storage.id}"
    delete = true
  }
}
