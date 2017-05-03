output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.cdn.domain_name}"
}

output "cloudfront_dns" {
  value = "${aws_route53_record.root-domain.fqdn}"
}

output "website_origin" {
  value = "${aws_s3_bucket.origin.website_endpoint}"
}

output "origin_bucket" {
  value = "${aws_s3_bucket.origin.bucket}"
}
