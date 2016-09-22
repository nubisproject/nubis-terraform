variable "account" {}

variable "region" {}

variable "environment" {}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "client_security_groups" {}
