variable "account" {
}

variable "region" {
}

variable "environment" {
}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}

variable "origin_bucket" {
}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "404.html"
}

variable acm-certificate-arn {
}
