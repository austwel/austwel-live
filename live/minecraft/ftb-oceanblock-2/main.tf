module "minecraft_server" {
  source = "../../../modules/minecraft_server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.15
  desired_capacity    = var.start_server ? 1 : 0

  # Instance Settings
  root_volume_size    = "8"
  name                = "FTB OceanBlock 2"
  uid                 = "ftb-oceanblock-2"
  memory_gib          = 16
  vcpu_count          = 2

  # Minecraft Settings
  modpack             = "ftb-oceanblock-2"
}

module "dns_record" {
  source = "../../../modules/dns"
  count = var.start_server ? 1 : 0

  name = "ob2"
  content = module.minecraft_server.elastic_ip[0]
  proxied = false
}

module "main_dns_record" {
  source = "../../../modules/dns"
  count = var.start_server && var.main_server ? 1 : 0

  name = "mc"
  content = module.minecraft_server.elastic_ip[0]
  proxied = false
}

output "ip_address" {
  value = module.minecraft_server.elastic_ip
  description = "Elastic IP Address"
}

output "asg_name" {
  value = module.minecraft_server.asg_name
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
