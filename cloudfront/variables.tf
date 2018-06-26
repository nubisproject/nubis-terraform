variable "account" {}

variable "region" {}

variable "environment" {}

variable "load_balancer_web" {}

variable "service_name" {}

variable "acm_certificate_domain" {}

variable "enabled" {
  default = false
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "domain_aliases" {
  type    = "list"
  default = []
}

variable "arena" {
  default = "core"
}
