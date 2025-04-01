module "instance" {
  source = "../ec2"

  spot_instance     = var.spot_instance

  ami               = var.ami_id
  instance_type     = var.instance_type
  root_volume_size  = var.root_volume_size
  instance_tags       = {
    "application" = "Minecraft Server"
    "modpack" = var.modpack
    "name" = var.name
  }

  volume_tags         = {
    "application" = "Minecraft Server Root Volume"
    "modpack" = var.modpack
    "name" = "${var.modpack}-root"
  }
}

module "volume" {
  source = "../ebs"

  for_each = { for volume in var.ebs_volumes : volume.device_name => volume }

  mount_point = each.value.mountpoint

  volume_size = each.value.size
  volume_type = each.value.type

  tags         = {
    "application" = "Minecraft Server Root Volume"
    "modpack" = var.modpack
    "name" = "${var.modpack}-root"
  }
}
