resource "aws_iam_role_policy" "sns_allowall" {
  name  = "sns_allowall"
  count = "${var.sns_allowall && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

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
