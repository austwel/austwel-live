module "ftb_oceanblock_2" {
  source = "./minecraft/ftb-oceanblock-2"

  start_server  = false
}

module "cosmic_frontiers_beta" {
  source = "./minecraft/cosmic-frontiers-0.7.0BE"

  start_server  = true
  main_server   = true
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

  asg_names = [module.ftb_oceanblock_2.asg_name, module.cosmic_frontiers_beta.asg_name]
  webhook_url = file("~/.discord/greg-webhook")
}

module "api" {
  source = "../modules/api"

  asg_names = [module.ftb_oceanblock_2.asg_name, module.cosmic_frontiers_beta.asg_name]
}

module "bot" {
  source = "../modules/bot"

  asg_name = module.cosmic_frontiers_beta.asg_name
  asg_human_name = "Cosmic Frontiers"
  bot_token = chomp(file("~/.discord/bot_token"))
  channel_id = "955388796382367744"
  message_id = "1377221230465388556"
  discord_public_key = chomp(file("~/.discord/public_key"))
  host_name = module.cosmic_frontiers_beta.dns_name
}

output "webhook_url" {
  value = module.bot.discord_webhook_url
}