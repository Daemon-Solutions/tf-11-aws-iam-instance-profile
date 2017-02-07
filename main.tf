# We use features that requires version 0.8.0 or higher
terraform {
  required_version = ">= 0.8.0"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-profile"
  roles = ["${aws_iam_role.default_role.name}"]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_iam_role" "default_role" {
  name = "${var.name}-default_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ec2_describe" {
  name = "ec2_describe"

  count = "${var.ec2_describe}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_attach" {
  name = "ec2_attach"

  count = "${var.ec2_attach}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Attach*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_readonly" {
  name = "s3_readonly"

  count = "${var.s3_readonly}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rds_readonly" {
  name = "rds_readonly"

  count = "${var.rds_readonly}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "rds:List*",
        "rds:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_readonly" {
  name = "cloudwatch_readonly"

  count = "${var.cw_readonly}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:List*",
        "cloudwatch:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_update" {
  name = "cloudwatch_update"

  count = "${var.cw_update}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:Put*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "r53_update" {
  name = "r53_update"

  count = "${var.r53_update}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "route53:List*",
        "route53:Get*",
        "route53:ChangeResourceRecordSets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "redshift_read" {
  name = "redshift_read"

  count = "${var.redshift_read}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "redshift:Describe*",
        "redshift:ViewQueriesInConsole",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeInternetGateways",
        "sns:Get*",
        "sns:List*",
        "cloudwatch:Describe*",
        "cloudwatch:List*",
        "cloudwatch:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_write" {
  name = "s3_write-${element(split(",", var.s3_write_buckets), count.index)}"

  count = "${var.s3_write_buckets != "" ? length(split(",", var.s3_write_buckets)) : 0}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${element(split(",", var.s3_write_buckets), count.index)}",
        "arn:aws:s3:::${element(split(",", var.s3_write_buckets), count.index)}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sns_allowall" {
  name = "sns_allowall"

  count = "${var.sns_allowall}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sqs_allowall" {
  name = "sqs_allowall"

  count = "${var.sqs_allowall}"
  role = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {

  count      = "${var.ssm_managed}"
  role      = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# KMS read policy document
data "aws_iam_policy_document" "kms_read_policy" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    resources = ["${split(",", var.kms_decrypt_arns)}"]
  }
}

# KMS read IAM role policy
resource "aws_iam_role_policy" "read_kms" {
  name = "read_kms"
  count = "${var.kms_decrypt}"
  role  = "${aws_iam_role.default_role.id}"
  lifecycle {
    create_before_destroy = true
  }
  policy = "${data.aws_iam_policy_document.kms_read_policy.json}"
}
