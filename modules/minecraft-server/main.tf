module "asg" {
  source = "../asg"

  ami_id                = var.ami_id
  application           = var.application
  name                  = var.name

  desired_capacity      = var.desired_capacity
  max_size              = 1
  min_size              = 0

  od_base_capacity      = var.spot_instance ? 0 : 1
  od_percent_above_base = 0
  spot_price            = var.spot_price

  volume_size           = var.root_volume_size

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tmpl", {
    ebs_volume_id = module.volume.ebs_volume.id
    aws_region    = var.aws_region
    device_name   = var.ebs_volume.device_name
    mountpoint    = var.ebs_volume.mountpoint
    elastic_ip    = aws_eip.elastic_ip.public_ip
    modpack       = var.modpack
    cf_api_key    = data.aws_secretsmanager_secret_version.cf_secret.secret_string
    name          = var.name
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
  domain = "vpc"

  tags = {
    "application" = "Minecraft Server Elastic IP"
    "modpack"     = var.modpack
    "Name"        = "${var.modpack}-eip"
  }
}

data "aws_secretsmanager_secret" "cf_secrets" {
  arn = "arn:aws:secretsmanager:ap-southeast-2:017820703778:secret:CURSEFORGE-4TNmeo"
}

data "aws_secretsmanager_secret_version" "cf_secret" {
  secret_id = data.aws_secretsmanager_secret.cf_secrets.id
}