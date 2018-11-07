resource "aws_iam_role_policy" "ec2_describe" {
  name  = "ec2_describe"
  count = "${var.ec2_describe}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_attach" {
  name  = "ec2_attach"
  count = "${var.ec2_attach}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Attach*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_ebs_attach" {
  name  = "ec2_ebs_attach"
  count = "${var.ec2_ebs_attach}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeVolume",
        "ec2:AttachVolume"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_eni_attach" {
  name  = "ec2_eni_attach"
  count = "${var.ec2_eni_attach}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeNetworkInterfaceAttribute",
        "ec2:AttachNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_write_tags" {
  name  = "ec2_write_tags"
  count = "${var.ec2_write_tags}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:CreateTags"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_assign_private_ip" {
  name  = "ec2_assign_private_ip"
  count = "${var.ec2_assign_private_ip}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:AssignPrivateIpAddresses"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
