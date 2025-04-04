output "asg" {
  value = module.asg
  description = "Minecraft Server autoscaling group"
}

output "elastic_ip" {
  value = length(aws_eip.elastic_ip) > 0 ? aws_eip.elastic_ip[*].public_ip : null
  description = "Elastic IP"
}