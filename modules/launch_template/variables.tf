variable "name" {
  type        = string
  description = "Name"
}

variable "application" {
  type        = string
  description = "Application"
}

variable "availability_zone" {
  type        = string
  default     = "ap-southeast-2a"
  description = "Availability Zone"
}

variable "key_name" {
  type        = string
  default     = "default"
  description = "Key Name"
}

variable "security_group_name" {
  type        = string
  default     = "launch-wizard-1"
  description = "Security Group Name"
}

variable "instance_types" {
  type        = set(string)
  default     = [ "r6a.large", "r6i.large", "r6in.large", "r5n.large", "r5a.large", "r5.large" ]
  description = "Instance Types"
}

variable "volume_size" {
  type        = number
  default     = 8
  description = "Volume Size"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "user_data" {
  type        = string
  default     = ""
  description = "User Data"
}

variable "spot_max_price_percent" {
  type        = number
  default     = 50
  description = "Max price percentage over lowest spot price"
}