module "asg" {
  source = "../asg"

  ami_id                = "ami-04b78e495d6db9297"
  application           = var.application
  name                  = var.name
  uid                   = var.uid

  desired_capacity      = var.desired_capacity
  max_size              = 1
  min_size              = 0

  od_base_capacity      = var.spot_instance ? 0 : 1
  od_percent_above_base = 0
  spot_price            = var.spot_price

  volume_size           = var.root_volume_size

  memory_mib            = var.memory_mib
  vcpu_count            = var.vcpu_count

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tmpl", {
    ebs_volume_id       = module.volume.ebs_volume.id
    aws_region          = var.aws_region
    device_name         = var.ebs_volume.device_name
    local_device_name   = var.ebs_volume.local_device_name
    mountpoint          = var.ebs_volume.mountpoint
    elastic_ip          = length(aws_eip.elastic_ip) > 0 ? aws_eip.elastic_ip[0].public_ip : ""
    modpack             = var.modpack
    cf_api_key          = data.aws_secretsmanager_secret_version.cf_secret.secret_string
    name                = var.name
    memory_mib          = "${var.memory_mib * 0.8}"
  }))
}

module "volume" {
  source = "../ebs"

  volume_size = var.ebs_volume.size
  volume_type = var.ebs_volume.type

  tags = {
    "application" = "Minecraft Server Volume"
    "modpack"     = var.modpack
    "Name"        = "${var.modpack}-data"
  }
}

resource "aws_eip" "elastic_ip" {
  count = var.desired_capacity > 0 ? 1 : 0
  domain = "vpc"

  tags = {
    "application" = "Minecraft Server Elastic IP"
    "modpack"     = var.modpack
    "Name"        = "${var.modpack}-eip"
  }
}

data "aws_secretsmanager_secret" "cf_secrets" {
  arn = "arn:aws:secretsmanager:ap-southeast-2:017820703778:secret:curseforge_api_key-zKpLdI"
}

data "aws_secretsmanager_secret_version" "cf_secret" {
  secret_id = data.aws_secretsmanager_secret.cf_secrets.id
}