variable "content" {
  type        = string
  description = "DNS address"
  default = "default.austwel.xyz"
}

variable "zone_id" {
  type        = string
  description = "Zone ID"
  default     = "ffb5c8391f2f1980fff249572a441e6b" 
}

variable "domain" {
  type        = string
  description = "Domain Name"
  default     = "austwel.xyz" 
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
  default     = true
  description = "Should record use cf proxy"
}

variable "cname_forward" {
  type        = string
  default     = null
  description = "Address to redirect to"
}