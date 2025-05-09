variable "availability_zone" {
  type        = string
  default     = "ap-southeast-2a"
  description = "Availability Zone"
}

variable "webhook_url" {
  description = "The webhook endpoint to receive ASG event data"
  type        = string
}

variable "asg_names" {
  description = "Names of the Auto Scaling Groups to monitor"
  type        = list(string)
}
