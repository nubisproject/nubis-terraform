# Nasty workaround for nested optionnal block
# Works, but edit carefully, if at all.
locals {
  server_side_encryption_configuration_enabled = [
    [[[]]],
    [[[
      {
        rule = [
          {
            apply_server_side_encryption_by_default = [
              {
                sse_algorithm = "aws:kms"
              },
            ]
          },
        ]
      },
    ]]],
  ]
}

resource "aws_s3_bucket" "bucket" {
  count = "${var.enabled}"

  # Bucket can't be more than 63 characters long, so truncate away randomness
  bucket = "${replace(data.template_file.random.rendered,"/^(.{63}).*/","$1")}"

  acl = "${var.acl}"

  # Allow destruction of non-empty buckets
  force_destroy = true

  versioning {
    enabled = true
  }

  website {
    index_document = "${var.website_index}"
  }

  lifecycle_rule {
    id      = "expiration"
    enabled = "${var.expiration_days >= "0" ? true : false }"

    expiration {
      days = "${var.expiration_days}"
    }
  }

  lifecycle_rule {
    id      = "transition-onezone_ia"
    enabled = "${lookup(var.transitions, "ONEZONE_IA", 0) >= "30" ? true : false }"

    transition {
      days          = "${lookup(var.transitions, "ONEZONE_IA", 0) >= "30" ? lookup(var.transitions, "ONEZONE_IA", 0) : 30 }"
      storage_class = "ONEZONE_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-standard_ia"
    enabled = "${lookup(var.transitions, "STANDARD_IA", 0) >= "30" ? true : false }"

    transition {
      days          = "${lookup(var.transitions, "STANDARD_IA", 0) >= "30" ? lookup(var.transitions, "STANDARD_IA", 0) : 30 }"
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-glacier"
    enabled = "${lookup(var.transitions, "GLACIER", 0) == "0" ? false : true }"

    transition {
      days          = "${lookup(var.transitions, "GLACIER", 0)}"
      storage_class = "GLACIER"
    }
  }

  server_side_encryption_configuration = "${local.server_side_encryption_configuration_enabled[signum(var.storage_encrypted_at_rest)]}"

  tags = {
    Name           = "${var.service_name}-${var.environment}-${var.purpose}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
  }
}

resource "aws_iam_role_policy" "bucket" {
  count = "${var.role_cnt}"
  name  = "${var.service_name}-${var.environment}-${var.purpose}-bucket-policy"
  role  = "${element(split(",",var.role), count.index)}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
  "Effect": "Allow",
  "Action": "s3:ListAllMyBuckets",
  "Resource": "arn:aws:s3:::*"
   },
   {
   "Effect": "Allow",
    "Action": [
    "s3:ListBucket"
        ],
    "Resource": "${aws_s3_bucket.bucket.arn}"
    },
            {
              "Effect": "Allow",
              "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
              ],
              "Resource": "${aws_s3_bucket.bucket.arn}/*"
             }

  ]
}
EOF
}

# TF 0.6 limitation
# Used as a stable random-number generator since we don't have random provider yet
resource "tls_private_key" "random" {
  algorithm = "ECDSA"
}

data "template_file" "random" {
  template = "$${bucket}-$${random}"

  vars = {
    random = "${tls_private_key.random.id}"
    bucket = "${var.service_name}-${var.environment}-${var.purpose}"
  }
}
