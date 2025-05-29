variable "runtime" {
  type = string
  default = "python3.10"
  description = "Python runtime"
}

variable "asg_name" {
  type = string
  description = "ASG name to hold a status message for"
}

variable "bot_token" {
  type = string
  description = "Secret token for bot"
}

variable "channel_id" {
  type = string
  description = "Channel ID to hold message"
}

variable "message_id" {
  type = string
  description = "Message ID to hold message"
}

variable "asg_human_name" {
  type = string
  description = "Human readable ASG name"
}

variable "host_name" {
  type = string
  description = "Connection address"
}

variable "discord_public_key" {}