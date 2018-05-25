variable "account" {}

variable "region" {}

variable "environment" {}

variable "load_balancer_name" {}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "acm_ssl_cert_arn" {
  default = ""
}

variable "domain_aliases" {
  type    = "list"
  default = []
}

variable "arena" {
  default = "core"
}
