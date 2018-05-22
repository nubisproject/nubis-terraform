# Database Module

## Example Usage

```toml
module "database" {
  source       = "github.com/nubisproject/nubis-terraform//database?ref=<version>"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"

  client_security_groups = "${module.worker.security_group}"

  # Options
  name                   = "testdb"
  username               = "testuser"
  monitoring             = false
  engine                 = "mysql"
  monitoring             = true

}

```

## Arguments

### client_security_groups (required)

A comma delimited list of allowed client security groups

### allocated_storage

The storage to allocate for the database in Megabytes

### engine

The database engine to use, allowed values are:

- mysql
- postgres

### engine_version

Version of the database engine to use, allowed values depends on Amazon RDS

Can specify a full version or a partial version prefix, i.e. 5.6.7 or just 5.6

### replica_count

The number of read-only database replicas to spin up

Default: 0

### instance_class

The database instance class to use for this database.

Allowes values : Any valid [AWS RDS Instance Type]( https://aws.amazon.com/rds/instance-types/)

### name

The name of the database

### username

The provisioned administrator username

### password

The provisioned administrator password

### backup_retention_period

Numbers of days to keep backups for, in days

Default: 7

### storage_type

The AWS storage type to use.

Allowed values:

- gp2
- io1
- magnetic

### multi_az

Controls if the database should span multiple AZes

Default: false

### monitoring

Controls if a monitoring instance is spun up alongside the database
to provide for monitoring and advanced telemetry

Default: false

### nubis_sudo_groups

Comma delimited list of groups allowed sudo onto the monitoring host

### nubis_user_groups

Comma delimited list of groups allowed login onto the monitoring host

### parameter_group_name

Name of the DB parameter group to use for this instance.

If not specified, one is automatically generated

### parameters

A map of additional parameters to include in the generated
parameter_group for this instance.
