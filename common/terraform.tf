terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "< 6.0"
      source  = "hashicorp/aws"
    }
    cloudflare = {
      version = "~> 5"
      source  = "cloudflare/cloudflare"
    }
  }
}
