data "aws_iam_policy_document" "kms_decrypt_policy" {
  count = "${var.kms_decrypt && var.enabled ? 1 : 0}"

  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncryptFrom",
    ]

    effect    = "Allow"
    resources = ["${split(",", var.kms_decrypt_arns)}"]
  }
}

resource "aws_iam_role_policy" "kms_decrypt" {
  name  = "kms_decrypt"
  count = "${var.kms_decrypt && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${join("", data.aws_iam_policy_document.kms_decrypt_policy.*.json)}"
}

data "aws_iam_policy_document" "kms_encrypt_policy" {
  count = "${var.kms_encrypt && var.enabled ? 1 : 0}"

  statement {
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:ReEncryptTo",
    ]

    effect    = "Allow"
    resources = ["${split(",", var.kms_encrypt_arns)}"]
  }
}

resource "aws_iam_role_policy" "kms_encrypt" {
  name  = "kms_encrypt"
  count = "${var.kms_encrypt && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${join("", data.aws_iam_policy_document.kms_encrypt_policy.*.json)}"
}
