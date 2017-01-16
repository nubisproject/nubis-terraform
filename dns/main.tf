module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_route53_record" "primary" {
  count   = "${1 - ( var.ipv4_alias * var.ipv6_alias )}"
  zone_id = "${module.info.hosted_zone_id}"
  name    = "${coalesce(var.name, "${var.prefix}.${var.service_name}-${var.environment}")}.${var.environment}"

  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${split(",",var.target)}"]
}

resource "aws_route53_record" "ipv4_alias" {
  count   = "${var.ipv4_alias}"
  zone_id = "${module.info.hosted_zone_id}"

  name = "${coalesce(var.name, "${var.prefix}.${var.service_name}-${var.environment}")}.${var.environment}"
  type = "A"

  alias {
    name                   = "${var.ipv4_target}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "ipv6_alias" {
  count   = "${var.ipv6_alias}"
  zone_id = "${module.info.hosted_zone_id}"

  name = "${coalesce(var.name, "${var.prefix}.${var.service_name}-${var.environment}")}.${var.environment}"
  type = "AAAA"

  alias {
    name                   = "${var.ipv6_target}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = true
  }
}
