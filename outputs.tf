output "profile_id" {
  value = "${aws_iam_instance_profile.instance_profile.id}"
}

output "profile_arn" {
  value = "${aws_iam_instance_profile.instance_profile.arn}"
}

output "profile_name" {
  value = "${aws_iam_instance_profile.instance_profile.name}"
}

output "profile_create_date" {
  value = "${aws_iam_instance_profile.instance_profile.create_date}"
}

output "profile_path" {
  value = "${aws_iam_instance_profile.instance_profile.path}"
}

output "profile_roles" {
  value = "${aws_iam_instance_profile.instance_profile.roles}"
}

output "profile_unique_id" {
  value = "${aws_iam_instance_profile.instance_profile.unique_id}"
}

output "role_arn" {
  value = "${aws_iam_role.default_role.arn}"
}
