module "minecraft_server" {
  source = "../../../modules/minecraft_server"

  # Pricing Settings
  spot_instance       = true
  spot_price          = 0.2
  desired_capacity    = var.start_server ? 1 : 0

  # Instance Settings
  root_volume_size    = "8"
  name                = "TFG"
  uid                 = "terrafirmagreg-modern"
  instance_type       = "t3a.large"

  # Schedule Settings
  schedule            = {     
#    scale_up   = "0 16 * * *"
    scale_up   = null
    scale_down = "0 2 * * 1,2,3,4,5"
  }

  # EBS Settings
  ebs_volume = {
    mountpoint = "/data",
    device_name = "/dev/xvdb",
    size = 16,
    type = "gp3",
    uid = null,
    gid = null,
    mode = null
  }

  # Minecraft Settings
  java_version        = "java21-graalvm"
  jvm_opts            = {
    jvm_opts = ""
    jvm_xx_opts = "-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1 -XX:AllocatePrefetchStyle=3 -XX:ConcGCThreads=10 -XX:+EagerJVMCI -XX:+UseG1GC -XX:MaxGCPauseMillis=130 -XX:G1NewSizePercent=28 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=20 -XX:G1MixedGCCountTarget=3 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5"
    jvm_dd_opts = "graal.TuneInlinerExploration=1 graal.CompilerConfiguration=enterprise graal.LoopRotation=true"
  }

  modpack             = "terrafirmagreg-modern"

  ### Automatic Server Pack ###
  modpack_zip         = "https://github.com/TerraFirmaGreg-Team/Modpack-Modern/releases/download/0.12.10/TerraFirmaGreg-Modern-0.12.10-serverpack.zip"

  ### Custom Server Pack ###
  # modpack_zip         = "https://github.com/Frontiers-PackForge/CosmicFrontiers/releases/download/0.8.0-nightly.008/Cosmic.Frontier.0.8.0-nightly.008.zip"
  # additional_envs     = [
  #   {key = "RCON_CMDS_STARTUP", val = "gamerule naturalRegeneration true,gamerule dodaylightcycle true"},
  #   {key = "CF_EXCLUDE_MODS", val = "875744,854213,250398,231275,511770,908741,844662,568563,915902,363363,367706,1113794,686911,525447,238747,581495,631278,1163800,334853,535489,306549,1223456"}
  # ]
}

module "dns_record" {
  source = "../../../modules/dns"

  name = "tfg"
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

output "dns_name" {
  value = module.dns_record.name
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
