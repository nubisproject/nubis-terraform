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

# Usual target
variable "target" {
  default = ""
}

# Flag to create an IPv4 Alias record
variable "ipv4_alias" {
  default = false
}

# IPv4 Target for Aliases
variable "ipv4_target" {
  default = ""
}

# Flag to create an IPv6 Alias record
variable "ipv6_alias" {
  default = false
}

# IPv6 Target for Aliases
variable "ipv6_target" {
  default = ""
}

variable "ttl" {
  default = 300
}

variable "type" {
  default = "CNAME"
}

variable "prefix" {
  default = "www"
}

variable "alias_zone_id" {
  default = ""
}

variable "name" {
  default = ""
}
