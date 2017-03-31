module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "bucket" {
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
                "s3:GetObject",
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
