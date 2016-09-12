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

variable "target" {}

variable "ttl" {
  default = 300
}

variable "type" {
  default = "CNAME"
}

variable "prefix" {
  default = "www"
}
