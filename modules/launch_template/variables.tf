variable "application" {
  type        = string
  description = "Application Name"
}

variable "availability_zone" {
  type        = string
  default     = "ap-southeast-2a"
  description = "Availability Zone"
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

locals {
  spot_bid = data.aws_ec2_spot_price.current_spot_price["r6a.large"].spot_price * 1.02
}