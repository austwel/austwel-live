variable "spot_instance" {
  type        = bool
  default     = false
  description = "Should instance be spot"
}

variable "memory_mib" {
  type        = number
  default     = 16384
  description = "Memory requirements for the instance"
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

variable "server_memory" {
  type        = string
  description = "Server Memory" 
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

variable "server_type" {
  type        = string
  default     = "vanilla"
  description = "Server mod type"
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
    size = 8,
    type = "gp3",
    uid = null,
    gid = null,
    mode = null }
  description = "Ebs volume to attach to the instance"
}
