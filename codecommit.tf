data "aws_iam_policy_document" "codecommit_gitpull" {
  statement {
    actions = [
      "codecommit:GitPull",
    ]

    effect = "Allow"

    resources = [
      "${formatlist("arn:aws:codecommit:*:*:%v", var.codecommit_gitpull_repos)}",
    ]
  }
}

resource "aws_iam_role_policy" "codecommit_gitpull" {
  name  = "codecommit_gitpull"
  count = "${var.codecommit_gitpull}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${data.aws_iam_policy_document.codecommit_gitpull.json}"
}

data "aws_iam_policy_document" "codecommit_gitpush" {
  statement {
    actions = [
      "codecommit:GitPush",
    ]

    effect = "Allow"

    resources = [
      "${formatlist("arn:aws:codecommit:*:*:%v", var.codecommit_gitpush_repos)}",
    ]
  }
}

resource "aws_iam_role_policy" "codecommit_gitpush" {
  name  = "codecommit_gitpush"
  count = "${var.codecommit_gitpush}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = "${data.aws_iam_policy_document.codecommit_gitpush.json}"
}
