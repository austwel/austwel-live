variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "r6a.large"
}

variable "spot_instance" {
  type        = bool
  default     = false
  description = "Should instance be spot"
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

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "root_volume_size" {
  type        = string
  description = "Root volume size in gigabytes"
}

variable "ebs_volumes" {
  type        = set(object({
    mountpoint  = string
    device_name = string
    size        = number
    type        = string
    uid         = string
    gid         = string
    mode        = string
  }))
  default = [
    { mountpoint = "/data", device_name = "/dev/xvdj", size = 8, type = "gp3", uid = null, gid = null, mode = null }
  ]
  description = "List of ebs volumes to set up on this server"
}
