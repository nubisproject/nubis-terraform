module "info" {
  source        = "../info"
  region        = "${var.region}"
  environment   = "${var.environment}"
  account       = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_route53_record" "root-domain" {
  zone_id = "${module.info.hosted_zone_id}"
  name    = "${var.origin_bucket}.${var.environment}"
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cdn.hosted_zone_id}"
    evaluate_target_health = false
  }

}

resource "aws_s3_bucket" "origin" {
  bucket  = "${var.origin_bucket}-${var.environment}"
  acl     = "public-read"
  policy  = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.origin_bucket}-${var.environment}/*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags {
    Name            = "${var.origin_bucket}-origin-bucket"
    Environment     = "${var.environment}"
    TechnicalOwner  = "${var.technical_owner}"
  }

}

resource "aws_cloudfront_distribution" "cdn" {
  depends_on = [ "aws_s3_bucket.origin"]

  enabled             = true
  comment             = "Static site for ${var.origin_bucket}-${var.environment}"
  default_root_object = "index.html"
  retain_on_delete    = true

  origin {
    domain_name = "${aws_s3_bucket.origin.bucket}.s3.amazonaws.com"
    origin_id   = "website-bucket-origin"
  }

  aliases = [
    "${var.origin_bucket}.${var.environment}.${var.region}.${var.account}.${var.nubis_domain}"
  ]

  default_cache_behavior {
    allowed_methods   = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods    = ["GET", "HEAD"]
    target_origin_id  = "website-bucket-origin"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 30
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags {
    Name            = "${var.origin_bucket}-cdn"
    TechnicalOwner  = "${var.technical_owner}"
    Environment     = "${var.environment}"
  }
}
