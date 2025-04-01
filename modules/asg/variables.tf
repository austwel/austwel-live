variable "application" {
  type        = string
  description = "Application Name"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone"
  default     = "ap-southeast-2a"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use"
}

variable "volume_size" {
  type        = number
  default     = 8
  description = "Volume Size"
}

variable "user_data" {
  type        = string
  description = "User Data"
}

variable "desired_capacity" {
  type        = number
  default     = 1
  description = "Desired Capacity"
}

variable "max_size" {
  type        = number
  default     = 1
  description = "Max Size"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Min Size"
}

variable "od_base_capacity" {
  type        = number
  default     = 0
  description = "On Demand Base Capacity"
}

variable  "od_percent_above_base" {
  type        = number
  default     = 0
  description = "On Demand Percentage Above Base Capacity"
}
