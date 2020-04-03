resource "aws_iam_role_policy" "sts_assumerole" {
  name  = "sts_assumerole"
  count = "${var.sts_assumerole && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${join("", data.aws_iam_policy_document.sts_assume_roles.*.json)}"
}

data "aws_iam_policy_document" "sts_assume_roles" {
  count = "${var.sts_assumerole && var.enabled ? 1 : 0}"

  statement {
    sid = "AllowAssumingRoles"

    actions = [
      "sts:AssumeRole",
    ]

    resources = "${var.sts_assumeroles}"
  }
}
