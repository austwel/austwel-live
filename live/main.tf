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
  source = "../modules/webhook"

  asg_names = [module.ftb_oceanblock_2.asg_name, module.cosmic_frontiers_beta.asg_name]
  webhook_url = file("~/.discord/greg-webhook")
}