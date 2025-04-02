variable "volume_size" {
  type        = string
  description = "Size of the volume in gigabytes"
}

variable "volume_type" {
  type        = string
  description = "AWS hardward for the volume, ie. gp4"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the volume"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone"
  default     = "ap-southeast-2a"
}