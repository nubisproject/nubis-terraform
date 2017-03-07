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
  bucket  = "${var.origin_bucket}-${var.environment}-${uuid()}"
  acl     = "public-read"
  policy  = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadForGetBucketObjects",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.origin_bucket}-${var.environment}-*/*"
    }
  ]
}
EOF

  website {
    index_document = "${coalesce(var.index_document, "index.html")}"
    error_document = "${coalesce(var.error_document, "404.html")}"
    routing_rules  = <<EOF
[
  {
    "Condition": {
      "KeyPrefixEquals": "/"
    },
    "Redirect": {
      "ReplaceKeyWith": "${coalesce(var.index_document, "index.html")}"
    }
  }
]
EOF
  }

  tags {
    Name            = "${var.origin_bucket}-origin-bucket"
    Environment     = "${var.environment}"
    TechnicalOwner  = "${var.technical_owner}"
  }

}

resource "aws_s3_bucket" "origin-logs" {
  bucket  = "${var.origin_bucket}-${var.environment}-logs-${uuid()}"
  acl     = "log-delivery-write"

  tags {
    Name            = "${var.origin_bucket}-origin-logs"
    Environment     = "${var.environment}"
    TechnicalOwner  = "${var.technical_owner}"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "${var.origin_bucket}-${var.environment}"
}

resource "aws_cloudfront_distribution" "cdn" {
  depends_on = [ "aws_s3_bucket.origin"]

  enabled             = true
  comment             = "Static site for ${var.origin_bucket}-${var.environment}"
  default_root_object = "${coalesce(var.index_document, "index.html")}"
  retain_on_delete    = true

  origin {
    domain_name = "${aws_s3_bucket.origin.bucket_domain_name}"
    origin_id   = "s3-${aws_s3_bucket.origin.bucket}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  aliases = [
    "${var.origin_bucket}.${var.environment}.${var.region}.${var.account}.${var.nubis_domain}"
  ]

  logging_config {
    include_cookies = false
    prefix          = "${aws_s3_bucket.origin.bucket}"
    bucket          = "${aws_s3_bucket.origin-logs.bucket_domain_name}"
  }

  default_cache_behavior {
    allowed_methods   = ["GET", "HEAD"]
    cached_methods    = ["GET", "HEAD"]
    target_origin_id  = "s3-${aws_s3_bucket.origin.bucket}"

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
