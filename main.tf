resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-profile"
  role = "${aws_iam_role.default_role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "default_role" {
  name = "${var.name}-default_role"

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
