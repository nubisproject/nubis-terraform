variable "enabled" {
  description = "Flag to enable or disable resource creation (Valid options are 1 or 0)"
  default     = "1"
}

variable "account" {}

variable "region" {}

variable "environment" {}

variable "arena" {
  default = "core"
}

variable "nubis_domain" {
  default = "nubis.allizom.org"
}
