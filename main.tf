resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-profile"
  roles = ["${aws_iam_role.default_role.name}"]
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
}

resource "aws_iam_role_policy" "ec2_describe" {
  name = "ec2_describe"

  count = "${var.ec2_describe}"
  role = "${aws_iam_role.default_role.id}"

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

