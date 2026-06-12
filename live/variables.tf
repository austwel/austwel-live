variable "webhook_url" {
  description = "Discord webhook URL for alerting"
  type        = string
  sensitive   = true
}

variable "bot_token" {
  description = "Discord bot token"
  type        = string
  sensitive   = true
}

variable "discord_public_key" {
  description = "Discord bot public key"
  type        = string
  sensitive   = true
}
