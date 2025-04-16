output "role_arn" {
  value = aws_iam_role.asg_scaler.arn
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.asg_scaler_profile.arn
}