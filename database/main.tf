locals {
  # Default TCP client port
  client_port = {
    mysql    = "3306"
    postgres = "5432"
  }

  # We need to know Amazon's defaults, unfortunately
  engine_version_defaults = {
    mysql    = "5.6"
    postgres = "9.6"
  }

  # Settle on which version to request
  engine_version = "${coalesce(var.engine_version, local.engine_version_defaults[var.engine])}"

  # just remove '.' from there, not allowed in names
  engine_version_clean = "${replace(local.engine_version, ".", "-")}"

  # Grab only the first 2 version components
  engine_version_family = "${join(".", slice(split(".", local.engine_version), 0, 2))}"

  default_parameters = {
    mysql = [
      {
        name         = "max_allowed_packet"
        value        = "1073741824"
        apply_method = "immediate"
      },
      {
        name         = "slow_query_log"
        value        = "1"
        apply_method = "immediate"
      },
    ]

    postgres = [
      {
        name         = "autovacuum"
        value        = 1
        apply_method = "immediate"
      },
      {
        name         = "log_min_duration_statement"
        value        = 250
        apply_method = "immediate"
      },
      {
        name         = "log_statement"
        value        = "none"
        apply_method = "immediate"
      },
      {
        name         = "log_duration"
        value        = 0
        apply_method = "immediate"
      },
    ]
  }
}

module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  arena       = "${var.arena}"
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

module "monitor-image" {
  source = "../images"

  region  = "${var.region}"
  project = "nubis-db-admin"

  # Just pick latest since we don't really know for sure
  image_version = "*"
}

module "monitor" {
  source       = "../worker"
  enabled      = "${var.monitoring}"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  ami          = "${module.monitor-image.image_id}"
  purpose      = "db-monitor-${var.engine}"

  nubis_sudo_groups = "${var.nubis_sudo_groups}"
  nubis_user_groups = "${var.nubis_user_groups}"

  instance_type = "t2.nano"
}

resource "aws_security_group" "database" {
  vpc_id = "${module.info.vpc_id}"
  name   = "${var.service_name}-${var.environment}-rds"

  tags = {
    Name           = "${var.service_name}-${var.environment}-rds"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }

  ingress {
    from_port = "${local.client_port[var.engine]}"
    to_port   = "${local.client_port[var.engine]}"
    protocol  = "tcp"

    cidr_blocks = [
      "${compact(split(",",var.client_ip_cidr))}",
    ]

    security_groups = [
      "${split(",",var.client_security_groups)}",
      "${compact(list(module.monitor.security_group))}",
    ]
  }

  ingress {
    self      = true
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
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

resource "aws_db_subnet_group" "database" {
  name        = "${var.service_name}-${var.environment}-rds-subnet-group"
  description = "${var.service_name}-${var.environment}-rds-subnet-group"

  subnet_ids = [
    "${split(",",module.info.private_subnets)}",
  ]

  tags {
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }
}

resource "aws_db_parameter_group" "pg" {
  count  = "${signum(length(var.parameter_group_name)) == 0 ? 1 : 0}"
  name   = "${var.engine}-${local.engine_version_clean}-${var.service_name}-${var.environment}-${var.name}"
  family = "${var.engine}${local.engine_version_family}"

  tags {
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }

  parameter = [
    "${concat(local.default_parameters[var.engine], var.parameters)}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "database" {
  allocated_storage = "${var.allocated_storage}"
  engine            = "${var.engine}"
  engine_version    = "${local.engine_version}"
  instance_class    = "${var.instance_class}"

  identifier = "${var.service_name}-${var.environment}"

  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true

  # Remove unsafe characters
  name     = "${replace(coalesce(var.name, var.service_name), "/[^a-zA-Z0-9_]/","")}"
  multi_az = "${var.multi_az}"

  username = "${var.username}"
  password = "${coalesce(var.password,data.template_file.password.rendered)}"

  backup_retention_period = "${var.backup_retention_period}"
  skip_final_snapshot     = true
  apply_immediately       = true
  storage_type            = "${var.storage_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.database.name}"
  parameter_group_name    = "${coalesce(var.parameter_group_name, join("",aws_db_parameter_group.pg.*.name))}"

  vpc_security_group_ids = [
    "${aws_security_group.database.id}",
  ]

  tags {
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}

resource "aws_db_instance" "replica" {
  count = "${var.replica_count}"

  identifier = "${var.service_name}-${var.environment}-slave-${count.index}"

  replicate_source_db = "${aws_db_instance.database.id}"
  instance_class      = "${var.instance_class}"
  storage_type        = "${var.storage_type}"

  apply_immediately   = true
  skip_final_snapshot = true

  tags {
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}

# TF 0.6 limitation
# Used as a stable random-number generator since we don't have random provider yet
resource "tls_private_key" "random" {
  algorithm = "ECDSA"
}

data "template_file" "password" {
  template = "$${password32}"

  vars = {
    password32 = "${replace(tls_private_key.random.id,"/^(.{32}).*/","$1")}"
  }
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "database" {
  # The rest, we publish to
  key {
    path   = "${module.consul.config_prefix}/Database/Name"
    value  = "${aws_db_instance.database.name}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Database/Server"
    value  = "${aws_db_instance.database.address}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Database/User"
    value  = "${aws_db_instance.database.username}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Database/Password"
    value  = "${aws_db_instance.database.password}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Database/Engine"
    value  = "${aws_db_instance.database.engine}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Database/Engine/VersionFamily"
    value  = "${local.engine_version_family}"
    delete = true
  }
}
