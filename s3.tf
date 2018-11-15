data "aws_iam_policy_document" "readonly_buckets" {
  count = "${var.s3_readonly && var.enabled ? 1 : 0}"

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
  count  = "${var.s3_readonly && var.enabled ? 1 : 0}"
  role   = "${join("", aws_iam_role.default_role.*.id)}"
  policy = "${join("", data.aws_iam_policy_document.readonly_buckets.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "write_buckets" {
  count = "${var.s3_write && var.enabled ? 1 : 0}"

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
  count  = "${var.s3_write && var.enabled ? 1 : 0}"
  role   = "${join("", aws_iam_role.default_role.*.id)}"
  policy = "${join("", data.aws_iam_policy_document.write_buckets.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}
