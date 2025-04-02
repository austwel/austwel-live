variable "spot_instance" {
  type        = bool
  default     = false
  description = "Should instance be spot"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User Data" 
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

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "root_volume_size" {
  type        = string
  description = "Root volume size in gigabytes"
}

variable "ebs_volume" {
  type        = object({
    mountpoint  = string
    device_name = string
    size        = number
    type        = string
    uid         = string
    gid         = string
    mode        = string
  })
  default = {
    mountpoint = "/data",
    device_name = "/dev/xvdj",
    size = 8,
    type = "gp3",
    uid = null,
    gid = null,
    mode = null }
  description = "Ebs volume to attach to the instance"
}
