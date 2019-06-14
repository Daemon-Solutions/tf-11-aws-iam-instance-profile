output "profile_id" {
  value = aws_iam_instance_profile.instance_profile[0].id
}

output "profile_arn" {
  value = aws_iam_instance_profile.instance_profile[0].arn
}

output "profile_name" {
  value = aws_iam_instance_profile.instance_profile[0].name
}

output "profile_path" {
  value = aws_iam_instance_profile.instance_profile[0].path
}

output "profile_role" {
  value = aws_iam_instance_profile.instance_profile[0].role
}

output "profile_unique_id" {
  value = aws_iam_instance_profile.instance_profile[0].unique_id
}

output "role_arn" {
  value = aws_iam_role.default_role[0].arn
}

output "role_id" {
  value = aws_iam_role.default_role[0].id
}
