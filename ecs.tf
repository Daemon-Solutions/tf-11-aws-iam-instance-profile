data "aws_iam_policy_document" "ecs_update" {
  count = var.ecs_update && var.enabled ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "ecs:UpdateTaskSet",
      "ecs:UpdateService",
      "ecs:UpdateCluster",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskSets",
      "ecs:DescribeServices",
      "ecs:DescribeClusters",
      "ecs:StopTask"
    ]

    resources = flatten([
      formatlist("%v", var.update_ecs_list),
      formatlist("%v/*", var.update_ecs_list),
    ])
  }

  statement {
    effect = "Allow"

    actions = [
      "ecs:ListTaskDefinitions",
      "ecs:ListServices",
      "ecs:ListClusters",
      "ecs:ListTasks"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_update" {
  name   = "ecs_update"
  count  = var.ecs_update && var.enabled ? 1 : 0
  role   = join("", aws_iam_role.default_role.*.id)
  policy = join("", data.aws_iam_policy_document.ecs_update.*.json)

  lifecycle {
    create_before_destroy = true
  }
}