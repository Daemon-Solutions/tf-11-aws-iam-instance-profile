resource "aws_iam_role_policy" "s3_readonly" {
  name  = "s3_read-${element(var.s3_read_buckets, count.index)}"
  count = "${length(var.s3_read_buckets)}"
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
      "Resource": [
        "arn:aws:s3:::${element(var.s3_read_buckets, count.index)}",
        "arn:aws:s3:::${element(var.s3_read_buckets, count.index)}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_write" {
  name  = "s3_write-${element(var.s3_write_buckets, count.index)}"
  count = "${length(var.s3_write_buckets)}"
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
        "arn:aws:s3:::${element(var.s3_write_buckets, count.index)}",
        "arn:aws:s3:::${element(var.s3_write_buckets, count.index)}/*"
      ]
    }
  ]
}
EOF
}
