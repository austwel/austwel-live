output "ebs_volume" {
  value       = aws_ebs_volume.ebs_volume
  description = "All EBS resource outputs"
}

output "volume_name" {
  value       = aws_ebs_volume.ebs_volume.tags_all.Name
}