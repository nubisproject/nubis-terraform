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

// Check interval in minutes
// Allowed values: 1, 5, 10, 15, 30, 60, 360, 720, or 1440
variable "frequency" {
  default = "60"
}

// SLA Treshold
variable "sla_treshold" {
  default = 7
}

//
variable "status" {
  default = "ENABLED"
}

// The type of monitor (one of SIMPLE, BROWSER, SCRIPT_API,
// SCRIPT_BROWSER)
variable "type" {
  default = "SCRIPT_BROWSER"
}

// The monitoring locations. A list can be found at the endpoint:
// https://synthetics.newrelic.com/synthetics/api/v1/locations
variable "locations" {
  type = "list"

  default = [
    "AWS_US_WEST_1",
    "LINODE_US_SOUTH_1",
  ]
}

variable "script_template" {
  default = "${path.module}/templates/script.tpl"
}
