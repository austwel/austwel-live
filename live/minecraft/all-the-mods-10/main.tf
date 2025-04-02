module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.1
  desired_capacity    = 1

  # Instance Settings
  root_volume_size    = "8"
  name                = "ATM 10"
  uid                 = "atm-10"

  # Minecraft Settings
  server_type         = "curseforge"
  modpack             = "all-the-mods-10"
}

output "ip_address" {
  value = module.minecraft_server.elastic_ip
  description = "Elastic IP Address"
}