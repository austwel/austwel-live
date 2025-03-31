variable "ami" {
  type        = string
  default     = ""
  description = "AMI ID to use"
}

variable "spot_price" {
  type        = string
  default     = null
  description = "Spot instance bid price"
}

variable "spot_instance" {
  type        = bool
  default     = false
  description = "Should instance be spot"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type to deploy"
}

variable "root_volume_size" {
  type        = number
  default     = 8
  description = "Size of the root volume in gigabytes"
}

variable "root_volume_type" {
  type        = string
  default     = "gp3"
  description = "Type of volume for root"
}

variable "volumes" {
  type        = list(map(string))
  default     = []
  description = "Extra volumes to attach"
}

variable "ebs_block_devices" {
  type        = list(any)
  default     = []
  description = "Adjust block devices"
}

variable "volume_tags" {
  type        = map(string)
  description = "Tags as kv pairs"
}

variable "instance_tags" {
  type        = map(string)
  description = "Tags as kv pairs"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone"
  default     = "ap-southeast-2a"
}
