resource "aws_iam_role_policy" "transcribe_fullaccess" {
  name  = "transcribe_fullaccess"
  count = "${var.transcribe_fullaccess}"
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
        "transcribe:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
