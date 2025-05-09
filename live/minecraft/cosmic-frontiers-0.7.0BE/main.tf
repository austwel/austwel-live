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
  memory_gib          = 8
  vcpu_count          = 2

  # Schedule Settings
  schedule            = {     
#    scale_up   = "0 6 * * *" # Turn on server at 0600Z ~ 4PM AEST
    scale_up   = null
    scale_down = "0 15 * * *" # Turn off server at 1500Z ~ 1AM AEST
  }

  # Minecraft Settings
  java_version        = "java21-graalvm"
  jvm_opts            = {
    jvm_opts = ""
    jvm_xx_opts = "+UnlockExperimentalVMOptions,+UnlockDiagnosticVMOptions,+AlwaysActAsServerClassMachine,+AlwaysPreTouch,+DisableExplicitGC,+UseNUMA,NmethodSweepActivity=1,ReservedCodeCacheSize=400M,NonNMethodCodeHeapSize=12M,ProfiledCodeHeapSize=194M,NonProfiledCodeHeapSize=194M,-DontCompileHugeMethods,MaxNodeLimit=240000,NodeLimitFudgeFactor=8000,+UseVectorCmov,+PerfDisableSharedMem,+UseFastUnorderedTimeStamps,+UseCriticalJavaThreadPriority,ThreadPriorityPolicy=1,AllocatePrefetchStyle=3,ConcGCThreads=10,+EagerJVMCI,+UseG1GC,MaxGCPauseMillis=130,G1NewSizePercent=28,G1HeapRegionSize=16M,G1ReservePercent=20,G1MixedGCCountTarget=3,InitiatingHeapOccupancyPercent=10,G1MixedGCLiveThresholdPercent=90,G1RSetUpdatingPauseTimePercent=0,SurvivorRatio=32,MaxTenuringThreshold=1,G1SATBBufferEnqueueingThresholdPercent=30,G1ConcMarkStepDurationMillis=5"
    jvm_dd_opts = "graal.TuneInlinerExploration=1,graal.CompilerConfiguration=enterprise,graal.LoopRotation=true"
  }

  modpack             = "cosmic-frontiers"
  modpack_zip         = "https://github.com/Frontiers-PackForge/CosmicFrontiers/releases/download/0.7.0-BE1/Cosmic.Frontiers.0.7.0.-.BE1.zip"
  additional_envs     = [
    {key = "RCON_CMDS_STARTUP", val = "gamerule naturalRegeneration true"},
    {key = "CF_EXCLUDE_MODS", val = "875744,854213,250398,231275,511770,908741,844662,915902,363363,367706,1113794,686911,525447,238747,581495,631278,1163800,334853,535489,306549"}]
}

module "dns_record" {
  source = "../../../modules/dns"
  count = var.start_server ? 1 : 0

  name = "cf"
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