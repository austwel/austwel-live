module "minecraft_server" {
  source = "../../../modules/minecraft_server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.15
  desired_capacity    = var.start_server ? 1 : 0

  # Instance Settings
  root_volume_size    = "8"
  name                = "Cosmic Frontiers"
  uid                 = "cosmic-frontiers"
  memory_mib          = 16384
  vcpu_count          = 2

  # Minecraft Settings
  server_memory       = "12G"
  server_type         = "curseforge"
  modpack             = "cosmic-frontiers"
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
