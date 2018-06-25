output "name" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.bucket.website_endpoint}"
}

output "hosted_zone_id" {
  value = "${aws_s3_bucket.bucket.hosted_zone_id}"
}
