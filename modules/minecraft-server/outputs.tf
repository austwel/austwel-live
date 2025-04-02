output "asg" {
  value = module.asg
  description = "Minecraft Server autoscaling group"
}

output "elastic_ip" {
  value = aws_eip.elastic_ip.public_ip
  description = "Elastic IP"
}