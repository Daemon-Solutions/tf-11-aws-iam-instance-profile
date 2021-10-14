resource "aws_iam_role_policy" "ads_domain_join" {
  name   = "ads_domain_join"
  count  = var.ads_domain_join && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.ads_domain_join[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ads_domain_join" {
  count = var.ads_domain_join && var.enabled ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ds:CreateComputer",
      "ds:DescribeDirectories"
    ]
  }
}
