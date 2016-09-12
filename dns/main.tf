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
  zone_id = "${module.info.hosted_zone_id}"
  name    = "${var.prefix}.${var.service_name}-${var.environment}.${var.environment}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${split(",",var.target)}"]
}
