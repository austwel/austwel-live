module "ftb_oceanblock_2" {
  source = "./minecraft/ftb-oceanblock-2"

  start_server  = false
}

module "cosmic_frontiers" {
  source = "./minecraft/cosmic-frontiers-0.6.0"

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