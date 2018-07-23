output "name" {
  value = "${element(concat(aws_s3_bucket.bucket.*.id, list("")), 0)}"
}

output "arn" {
  value = "${element(concat(aws_s3_bucket.bucket.*.arn, list("")), 0)}"
}

output "website_endpoint" {
  value = "${element(concat(aws_s3_bucket.bucket.*.website_endpoint, list("")), 0)}"
}

output "hosted_zone_id" {
  value = "${element(concat(aws_s3_bucket.bucket.*.hosted_zone_id, list("")), 0)}"
}
