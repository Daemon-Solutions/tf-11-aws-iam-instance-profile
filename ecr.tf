data "aws_iam_policy_document" "readonly_ecr" {
  count = var.ecr_readonly && var.enabled ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:UploadLayerPart",
      "ecr:PutImage",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:GetRepositoryPolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:CompleteLayerUpload",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]

    resources = flatten([
      formatlist("%v", var.read_ecr_list),
      formatlist("%v/*", var.read_ecr_list),
    ])
  }
}

resource "aws_iam_role_policy" "ecr_readonly" {
  name   = "ecr_readonly"
  count  = var.ecr_readonly && var.enabled ? 1 : 0
  role   = join("", aws_iam_role.default_role.*.id)
  policy = join("", data.aws_iam_policy_document.readonly_ecr.*.json)

  lifecycle {
    create_before_destroy = true
  }
}
