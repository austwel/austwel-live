variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
}

variable "profile_name" {
  description = "Name of the IAM Instance Profile"
  type        = string
}

variable "trusted_entity" {
  description = "The entity that can assume this role (like ec2.amazonaws.com or a friend's AWS Account ARN)"
  type        = string
}