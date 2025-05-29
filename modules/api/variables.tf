variable "asg_names" {
  description = "List of names of the Auto Scaling Groups"
  type        = list(string)
}

variable "region" {
  default = "ap-southeast-2"
}