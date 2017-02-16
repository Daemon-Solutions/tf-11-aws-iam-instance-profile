data "aws_iam_policy_document" "kms_read_policy" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    effect = "Allow"
    resources = ["${split(",", var.kms_decrypt_arns)}"]
  }
}

# KMS read IAM role policy
resource "aws_iam_role_policy" "read_kms" {
  name = "read_kms"
  count = "${var.kms_decrypt}"
  role  = "${aws_iam_role.default_role.id}"
  lifecycle {
    create_before_destroy = true
  }
  policy = "${data.aws_iam_policy_document.kms_read_policy.json}"
}