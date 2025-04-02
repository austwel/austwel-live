variable "zone_id" {
  type        = string
  default     = "ffb5c8391f2f1980fff249572a441e6b"
  description = "Zone ID"
}

variable "ip_address" {
  type        = string
  description = "DNS Ip address"
}

variable "name" {
  type        = string
  description = "DNS resolution name"
}

variable "type" {
  type        = string
  default     = "A"
  description = "Record type"
}

variable "proxied" {
  type        = bool
  default     = false
  description = "Should record use cf proxy"
}