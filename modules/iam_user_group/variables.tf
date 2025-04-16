variable "group_name" {
  description = "Name of the IAM group to create"
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "policy_description" {
  description = "Description of the IAM policy"
  type        = string
  default     = ""
}

variable "policy_statements" {
  description = "List of IAM policy statements in JSON format"
  type        = list(any)
}

variable "user_names" {
  description = "List of IAM user names to create and add to the group"
  type        = list(string)
  default     = []
}