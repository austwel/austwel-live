terraform {
  required_version = ">= 1.2"

  required_providers {
    cloudflare = {
      version = "~> 5"
      source  = "cloudflare/cloudflare"
    }
    aws = ">= 5.0"
  }
}
