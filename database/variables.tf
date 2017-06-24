variable "account" {}

variable "region" {}

variable "environment" {}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "client_security_groups" {}

variable "client_ip_cidr" {
  default = ""
}

variable "allocated_storage" {
  default = 10
}

variable "engine" {
  default = "mysql"
}

variable "replica_count" {
  default = 0
}

variable "instance_class" {
  default = "db.t1.micro"
}

variable "name" {
  default = ""
}

variable "password" {
  default = ""
}

variable "username" {
  default = "admin"
}

variable "backup_retention_period" {
  default = 7
}

variable "storage_type" {
  default = "gp2"
}

variable "multi_az" {
  default = false
}

variable "parameter_group_name" {
  default = ""
}

variable "monitoring" {
  default = false
}
