resource "aws_iam_role_policy_attachment" "ssm_managed" {

  count      = "${var.ssm_managed}"
  role      = "${aws_iam_role.default_role.id}"

  lifecycle {
    create_before_destroy = true
  }

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
