resource "aws_iam_role_policy" "secrets_manager_read" {
  name   = "secrets_manager_read"
  count  = var.secrets_manager_read && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.secrets_manager_read[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "secrets_manager_read" {
  count = var.secrets_manager_read && var.enabled ? 1 : 0

  statement {
    actions = [
      "secretsmanager:Describe*",
      "secretsmanager:Get*",
      "secretsmanager:List*",
    ]
    effect = "Allow"
    resources = flatten([
      formatlist("%v", var.secrets_manager_read_list)
    ])
  }
}
