module "all_the_mods_10" {
  source = "./minecraft/all-the-mods-10"
  
  start_server  = false
}

module "ftb_oceanblock_2" {
  source = "./minecraft/ftb-oceanblock-2"

  start_server  = true
  main_server   = true
}