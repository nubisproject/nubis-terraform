module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

# CloudFront requires ACM cert to reside in US east region
provider "aws" {
  region = "us-east-1"
  alias  = "acm-data-provider"
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  count = "${var.enabled ? 1 : 0}"

  origin {
    domain_name = "${var.load_balancer_web}"
    origin_id   = "${var.service_name}-${var.environment}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
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
    acm_certificate_arn = "${data.aws_acm_certificate.acm_tf.arn}"
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

data "aws_acm_certificate" "acm_tf" {
  count    = "${var.enabled ? 1 : 0}"
  domain   = "${var.acm_certificate_domain}"
  statuses = ["ISSUED"]
  provider = "aws.acm-data-provider"
}
