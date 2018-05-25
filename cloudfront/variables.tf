variable "account" {}

variable "region" {}

variable "environment" {}

variable "load_balancer_web" {}

variable "service_name" {
  default = "nubis"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

# Provide the CN of the ACM certificate
variable "acm_certificate_domain" {
  default = ""
}

variable "domain_aliases" {
  type    = "list"
  default = []
}

variable "arena" {
  default = "core"
}
