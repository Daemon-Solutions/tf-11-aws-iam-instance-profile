resource "aws_iam_role_policy" "s3_readonly" {
  name  = "s3_readonly"
  count = "${var.s3_readonly}"
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

resource "aws_iam_role_policy" "s3_write" {
  name  = "s3_write-${element(split(",", var.s3_write_buckets), count.index)}"
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
