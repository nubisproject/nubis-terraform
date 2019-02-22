variable "account" {}

variable "region" {}

variable "environment" {}

variable "instance_type" {
  default = "cache.t2.micro"
}

variable "service_name" {}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "client_security_groups" {
  default = ""
}

variable "arena" {
  default = "core"
}

variable "engine" {
  default = "memcached"
}
