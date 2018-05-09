data "aws_iam_policy_document" "firehose_streams" {
  count = "${var.firehose_streams}"

  statement {
    effect = "Allow"

    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    resources = ["${var.firehose_stream_arns}"]
  }
}

resource "aws_iam_role_policy" "firehose_streams" {
  count = "${var.firehose_streams}"

  name   = "firehose_streams"
  role   = "${aws_iam_role.default_role.id}"
  policy = "${join("", data.aws_iam_policy_document.firehose_streams.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}
