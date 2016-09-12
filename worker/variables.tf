variable "account" {}

variable "region" {}

variable "environment" {}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "ami" {}

variable "migrate" {
  default = 1
}

variable "instance_type" {
  default = "t2.nano"
}

variable "service_name" {
  default = "nubis"
}

variable "purpose" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "ssh_key_name" {
  default = "nubis"
}

variable "consul_token" {
  default = "anonymous"
}

variable "desired_instances" {
  default = 1
}

variable "min_instances" {
  default = 1
}

variable "security_group" {
  default = ""
}

variable "nubis_version" {
  default = ""
}

variable "wait_for_capacity_timeout" {
  default = "10m"
}

variable "health_check_type" {
  default = ""
}

variable "health_check_grace_period" {
  default = "300"
}

variable "elb" {
  default = ""
}

variable "instance_profile" {
  default = ""
}

variable "role" {
  default = ""
}

variable "monitoring" {
  default = "0"
}
