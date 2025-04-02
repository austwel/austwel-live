module "minecraft_server" {
  source = "../../../modules/minecraft-server"

  spot_instance       = true
  spot_price          = 0.06
  desired_capacity    = 1

  ami_id              = "ami-0247cc7ea18d45e33"
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"
  modpack             = "ftb-oceanblock-2"
}