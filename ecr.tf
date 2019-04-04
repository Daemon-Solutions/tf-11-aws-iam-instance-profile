data "aws_iam_policy_document" "ecr_readonly" {
  count = "${var.ecr_readonly && var.enabled ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "ecr:List*",
      "ecr:Get*",
      "ecr:Describe*",
      "ecr:Batch*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecr_readonly" {
  name   = "ecr_readonly"
  count  = "${var.ecr_readonly && var.enabled ? 1 : 0}"
  role   = "${join("", aws_iam_role.default_role.*.id)}"
  policy = "${join("", data.aws_iam_policy_document.ecr_readonly.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ecr_write" {
  count = "${var.ecr_write && var.enabled ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "ecr:List*",
      "ecr:Get*",
      "ecr:Describe*",
      "ecr:Batch*",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecr_write" {
  name   = "ecr_write"
  count  = "${var.ecr_write && var.enabled ? 1 : 0}"
  role   = "${join("", aws_iam_role.default_role.*.id)}"
  policy = "${join("", data.aws_iam_policy_document.ecr_write.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ecr_allowall" {
  count = "${var.ecr_allowall && var.enabled ? 1 : 0}"

  statement {
    effect = "Allow"

    actions = [
      "ecr:*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecr_allowall" {
  name   = "ecr_allowall"
  count  = "${var.ecr_allowall && var.enabled ? 1 : 0}"
  role   = "${join("", aws_iam_role.default_role.*.id)}"
  policy = "${join("", data.aws_iam_policy_document.ecr_allowall.*.json)}"

  lifecycle {
    create_before_destroy = true
  }
}
