data "aws_iam_policy_document" "readonly_buckets" {
  statement {
    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "${formatlist("arn:aws:s3:::%v", var.s3_read_buckets)}",
      "${formatlist("arn:aws:s3:::%v/*", var.s3_read_buckets)}",
    ]
  }
}

resource "aws_iam_role_policy" "s3_readonly" {
  name   = "s3_readonly"
  count  = "${length(var.s3_read_buckets) >= 1 ? 1 : 0}"
  role   = "${aws_iam_role.default_role.id}"
  policy = "${data.aws_iam_policy_document.readonly_buckets.json}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "write_buckets" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "${formatlist("arn:aws:s3:::%v", var.s3_write_buckets)}",
      "${formatlist("arn:aws:s3:::%v/*", var.s3_write_buckets)}",
    ]
  }
}

resource "aws_iam_role_policy" "s3_write" {
  name   = "s3_write"
  count  = "${length(var.s3_write_buckets) >= 1 ? 1 : 0}"
  role   = "${aws_iam_role.default_role.id}"
  policy = "${data.aws_iam_policy_document.write_buckets.json}"

  lifecycle {
    create_before_destroy = true
  }
}
