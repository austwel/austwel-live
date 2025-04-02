module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.1
  desired_capacity    = 1

  # Instance Settings
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"
  uid                 = "ftb-oceanblock-2"

  # Minecraft Settings
  server_type         = "curseforge"
  modpack             = "ftb-oceanblock-2"
}

output "ip_address" {
  value = module.minecraft_server.elastic_ip
  description = "Elastic IP Address"
}