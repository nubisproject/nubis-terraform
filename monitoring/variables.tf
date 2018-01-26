variable "account" {}

variable "region" {}

variable "environment" {}

variable "arena" {
  default = "core"
}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "url" {}
