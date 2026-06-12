module "ftb_oceanblock_2" {
  count = 0
  source = "./minecraft/ftb-oceanblock-2"

  start_server  = false
}

module "cosmic_frontiers" {
  count = 0
  source = "./minecraft/cosmic-frontiers"

  start_server  = false
}

module "tfg" {
  source = "./minecraft/tfg"

  start_server = true
  main_server = true
}

module "access" {
  source = "./iam"
}

module "console" {
  source = "../modules/dns"

  name = "aws"
  type = "CNAME"
  cname_forward = "https://austwel.signin.aws.amazon.com/console"
}

module "alerting" {
  count = 0
  source = "../modules/webhook"

  asg_names = [module.tfg.asg_name]
  webhook_url = var.webhook_url
}

module "api" {
  source = "../modules/api"

  asg_names = [module.tfg.asg_name]
}

module "bot" {
  source = "../modules/bot"

  asg_name = module.tfg.asg_name
  asg_human_name = "TerraFirmaGreg"
  bot_token = var.bot_token
  channel_id = "955388796382367744"
  message_id = "1377221230465388556"
  discord_public_key = var.discord_public_key
  host_name = module.tfg.dns_name
}

output "webhook_url" {
  value = module.bot.discord_webhook_url
}
