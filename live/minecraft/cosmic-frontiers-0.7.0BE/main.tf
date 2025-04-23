module "minecraft_server" {
  source = "../../../modules/minecraft_server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.2
  desired_capacity    = var.start_server ? 1 : 0

  # Instance Settings
  root_volume_size    = "8"
  name                = "Cosmic Frontiers 0.7.0BE"
  uid                 = "cosmic-frontiers-0-7-0BE"
  memory_gib          = 16
  vcpu_count          = 2

  # Schedule Settings
  schedule            = {
    scale_up = "0 6 * * *" # Turn on server at 0600Z ~ 4PM AEST
    scale_down = "0 18 * * *" # Turn off server at 1500Z ~ 4AM AEST
  }

  # Minecraft Settings
  modpack             = "cosmic-frontiers"

  modpack_zip         = "https://github.com/Frontiers-PackForge/CosmicFrontiers/releases/download/0.7.0-BE1/Cosmic.Frontiers.0.7.0.-.BE1.zip"
  additional_envs     = [{
    key = "RCON_CMDS_STARTUP"
    val = "gamerule naturalRegeneration true"
  }]
}

module "dns_record" {
  source = "../../../modules/dns"
  count = var.start_server ? 1 : 0

  name = "cf.austwel.xyz"
  ip_address = module.minecraft_server.elastic_ip[0]
}

module "main_dns_record" {
  source = "../../../modules/dns"
  count = var.start_server && var.main_server ? 1 : 0

  name = "mc.austwel.xyz"
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

variable "main_server" {
  type        = bool
  default     = false
  description = "Point main mc dns to this server"
}