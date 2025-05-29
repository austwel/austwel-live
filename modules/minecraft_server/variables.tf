variable "spot_instance" {
  type        = bool
  default     = false
  description = "Should instance be spot"
}

variable "instance_type" {
  type        = string
  default     = "t3a.large"
  description = "Acceptable instance type"
}

variable "memory_gib" {
  type        = number
  description = "Memory requirements for the instance"
  default     = 16 * 1024
}

variable "vcpu_count" {
  type        = number
  default     = 2
  description = "CPU requirements for the instance"
}

variable "spot_price" {
  type        = number
  description = "Spot Price Bid"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User Data" 
}

variable "java_version" {
  type        = string
  default     = "latest"
  description = "Java version to use"
}

variable "jvm_opts" {
  type        = object({
    jvm_opts    = string
    jvm_xx_opts = string
    jvm_dd_opts = string
  })
  default = {
    jvm_opts    = ""
    jvm_xx_opts = ""
    jvm_dd_opts = ""
  }
  description = "Java (and -XX -D opts) for the container"
}

variable "server_memory" {
  type        = number
  description = "Server Memory"
  default = null
}

variable "uid" {
  type        = string
  description = "Unique server id"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "AWS Region"
}

variable "application" {
  type        = string
  description = "Application Name"
  default     = "minecraft-server"
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired Instance Count"
}

variable "name" {
  type        = string
  description = "Instance name"
  default     = "Minecraft Server"
}

variable "modpack" {
  type        = string
  description = "Minecraft modpack"
  default     = "vanilla"
}

variable "root_volume_size" {
  type        = string
  description = "Root volume size in gigabytes"
}

variable "schedule" {
  type = object ({
    scale_up    = string
    scale_down  = string
  })
  default = null
  description = "Schedule to start/stop the server"
}

variable "modpack_zip" {
  type = string
  description = "Custom modpack zip location"
  default = ""
}

variable "additional_envs" {
  type = list(object({
    key = string
    val = string
  }))
  description = "More environment variables to pass"
  default = []
}

variable "ebs_volume" {
  type        = object({
    mountpoint        = string
    device_name       = string
    size              = number
    type              = string
    uid               = string
    gid               = string
    mode              = string
  })
  default = {
    mountpoint = "/data",
    device_name = "/dev/xvdb",
    size = 16,
    type = "gp3",
    uid = null,
    gid = null,
    mode = null }
  description = "Ebs volume to attach to the instance"
}
