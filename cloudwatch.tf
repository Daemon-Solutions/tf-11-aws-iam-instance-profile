resource "aws_iam_role_policy" "cloudwatch_readonly" {
  name  = "cloudwatch_readonly"
  count = "${var.cw_readonly && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:List*",
        "cloudwatch:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_update" {
  name  = "cloudwatch_update"
  count = "${var.cw_update && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:Put*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_logs_update" {
  name  = "cloudwatch_logs_update"
  count = "${var.cw_logs_update && var.enabled ? 1 : 0}"
  role  = "${join("", aws_iam_role.default_role.*.id)}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccessToCloudWatch",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

