module "minecraft_server" {
  source = "../../../modules/minecraft_server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.1
  desired_capacity    = var.start_server ? 1 : 0

  # Instance Settings
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"
  uid                 = "ftb-oceanblock-2"

  # Minecraft Settings
  server_type         = "curseforge"
  modpack             = "ftb-oceanblock-2"
}

module "dns_record" {
  source = "../../../modules/dns"
  count = var.start_server ? 1 : 0

  name = "ob2.austwel.xyz"
  ip_address = module.minecraft_server.elastic_ip[0]
}

output "ip_address" {
  value = module.minecraft_server[*].elastic_ip
  description = "Elastic IP Address"
}

variable "start_server" {
  type        = bool
  default     = true
  description = "Should the server be running"
}
