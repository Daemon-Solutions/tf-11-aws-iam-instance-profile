resource "aws_iam_role_policy" "ads_domain_join" {
  name  = "ads_domain_join"
  count = "${var.ads_domain_join}"
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
        "ds:CreateComputer",
        "ds:DescribeDirectories"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}