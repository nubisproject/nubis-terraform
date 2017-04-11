output "name" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "website_endpoint" {
  value = "${aws_s3_bucket.bucket.website_endpoint}"
}
