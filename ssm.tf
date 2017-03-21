resource "aws_iam_role_policy_attachment" "ssm_managed" {
  count = "${var.ssm_managed}"
  role  = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
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
      "ssm:DeleteParameter"
   ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
