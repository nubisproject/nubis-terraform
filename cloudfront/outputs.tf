output "cloudfront_domain_name" {
  value = "${element(concat(aws_cloudfront_distribution.cloudfront_distribution.*.domain_name, list("")), 0)}"
}

output "cloudfront_arn" {
  value = "${element(concat(aws_cloudfront_distribution.cloudfront_distribution.*.arn, list("")), 0)}"
}

output "cloudfront_id" {
  value = "${element(concat(aws_cloudfront_distribution.cloudfront_distribution.*.id, list("")), 0)}"
}
