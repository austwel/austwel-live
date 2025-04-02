output "launch_template_id" {
  value       = aws_launch_template.launch_template.id
  description = "Launch Template"
}

output "launch_template_version" {
  value       = aws_launch_template.launch_template.latest_version
  description = "Launch Template Version"
}