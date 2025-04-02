module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.1
  desired_capacity    = 1

  # Instance Settings
  ami_id              = "ami-0247cc7ea18d45e33"
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"

  # Minecraft Settings
  server_type         = "curseforge"
  modpack             = "ftb-oceanblock-2"
}