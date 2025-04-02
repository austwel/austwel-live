locals {
  id_normal = !var.spot_instance ? aws_instance.instance[0].id : null
  id_spot = var.spot_instance ? aws_spot_instance_request.instance_spot[0].id : null
  id = coalesce(local.id_normal, local.id_spot)

  ip_normal = !var.spot_instance ? aws_instance.instance[0].private_ip: null
  ip_spot =  var.spot_instance ? aws_spot_instance_request.instance_spot[0].private_ip : null
  ip = coalesce(local.ip_normal, local.ip_spot)

  ami_normal = !var.spot_instance ? aws_instance.instance[0].ami : null
  ami_spot = var.spot_instance ? aws_spot_instance_request.instance_spot[0].ami : null
  ami_id = coalesce(local.ami_normal, local.ami_spot)
}

output "id" {
  value       = local.id
  description = "EC2 instance ID"
}

output "private_ip" {
  value       = local.ip
  description = "EC2 instance private ip"
}

output "volumes" {
  value       = var.volumes
  description = "EC2 instance extra volumes (no root)"
}

output "ami" {
  value       = local.ami_id
  description = "EC2 instance AMI ID"
}
