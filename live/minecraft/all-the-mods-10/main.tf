module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.1
  desired_capacity    = 1

  # Instance Settings
  ami_id              = "ami-0247cc7ea18d45e33"
  root_volume_size    = "8"
  name                = "ATM 10"

  # Minecraft Settings
  server_type         = "curseforge"
  modpack             = "all-the-mods-10"
}

output "ip_address" {
  value = module.minecraft_server.aws_eip.elastic_ip.public_ip
  description = "Elastic IP Address"
}