module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  spot_instance       = true

  ami_id              = "ami-0247cc7ea18d45e33"
  instance_type       = "r6a.large"
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"
  modpack             = "ftb-oceanblock-2"
}
