module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = "${var.load_balancer_web}"
    origin_id   = "${var.service_name}-${var.environment}"
  }

  enabled = true
  comment = "${var.service_name}-${var.environment}"
  aliases = "${var.domain_aliases}"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.service_name}-${var.environment}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  tags {
    Name           = "${var.service_name}-${var.environment}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }

  viewer_certificate {
    acm_certificate_arn = "${acm_certificate.arn}"
    ssl_support_method  = "sni-only"
  }
}

data "aws_acm_certificate" "acm_certificate" {
  domain   = "${var.acm_certificate_domain}"
  statuses = ["ISSUED"]
}
