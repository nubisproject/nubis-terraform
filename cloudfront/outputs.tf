output "cloudfront_domain_name" {
  value = "${aws_cloudfront_distribution.cloudfront_distribution.domain_name}"
}

output "cloudfront_status" {
  value = "${aws_cloudfront_distribution.cloudfront_distribution.status}"
}

output "cloudfront_arn" {
  value = "${aws_cloudfront_distribution.cloudfront_distribution.arn}"
}

output "cloudfront_id" {
  value = "${aws_cloudfront_distribution.cloudfront_distribution.id}"
}
