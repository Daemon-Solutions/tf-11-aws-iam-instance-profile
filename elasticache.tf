resource "aws_iam_role_policy" "elasticache_readonly" {
  name = "elasticache_readonly"

  count = "${var.elasticache_readonly}"
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
        "elasticache:Describe*",
        "elasticache:ListTagsForResource"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

