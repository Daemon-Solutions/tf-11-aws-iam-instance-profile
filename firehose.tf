resource "aws_iam_role_policy" "firehose_streams" {
  name  = "firehose_streams"
  count = "${var.firehose_streams}"
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
        "firehose:PutRecordBatch"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
