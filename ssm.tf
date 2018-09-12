data "aws_iam_policy_document" "ssm_get_params" {
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
    ]

    resources = ["${formatlist("arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/%v", var.ssm_get_params_names)}"]
  }
}

resource "aws_iam_role_policy" "ssm_get_params" {
  count = "${var.ssm_get_params}"

  name   = "ssm_get_params"
  role   = "${aws_iam_role.default_role.id}"
  policy = "${data.aws_iam_policy_document.ssm_get_params.json}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ssm_managed" {
  name  = "ssm_managed"
  count = "${(var.ssm_managed || var.ssm_session_manager) ? 1 : 0}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ssm_parameter_allow_all" {
  name  = "ssm_parameter_allow_all"
  count = "${var.ssmparameter_allowall}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action":[
      "ssm:DescribeParameter",
      "ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:DeleteParameter"
   ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ssm_session_manager" {
  count = "${var.ssm_session_manager}"

  statement {
    effect = "Allow"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetEncryptionConfiguration",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ssm_session_manager" {
  count = "${var.ssm_session_manager}"

  name   = "ssm_session_manager"
  role   = "${aws_iam_role.default_role.id}"
  policy = "${data.aws_iam_policy_document.ssm_session_manager.json}"

  lifecycle {
    create_before_destroy = true
  }
}
