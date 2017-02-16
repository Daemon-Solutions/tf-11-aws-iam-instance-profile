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