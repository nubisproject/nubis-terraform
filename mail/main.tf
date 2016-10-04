module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_iam_access_key" "email" {
  user = "${aws_iam_user.email.name}"
}

resource "aws_iam_user" "email" {
  name = "${var.service_name}-${var.environment}-ses"
}

resource "aws_iam_user_policy" "email" {
  name = "${var.service_name}-${var.environment}-ses-policy"
  user = "${aws_iam_user.email.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
       "Effect": "Allow",
       "Action": ["ses:SendEmail", "ses:SendRawEmail"],
       "Resource":"*"
     }
  ]
}
EOF
}
