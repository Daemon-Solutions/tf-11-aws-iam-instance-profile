resource "aws_iam_instance_profile" "instance_profile" {
  count = "${var.enabled ? 1 : 0}"
  name  = "${var.name}-profile"
  role  = "${join("", aws_iam_role.default_role.*.name)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "default_role" {
  count = "${var.enabled ? 1 : 0}"
  name  = "${var.name}-default_role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_policies" {
  count = "${var.enabled ? length(var.aws_policies) : 0}"

  role       = "${join("", aws_iam_role.default_role.*.id)}"
  policy_arn = "arn:aws:iam::aws:policy/${element(var.aws_policies, count.index)}"

  lifecycle {
    create_before_destroy = true
  }
}
