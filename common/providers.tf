provider "aws" {
  region  = local.aws_region

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  shared_credentials_files = ["~/.aws/credentials"]
  profile = "default"
}

provider "cloudflare" {
  api_token = file("~/.cloudflare/credentials")
}

locals {
  # Sydney
  aws_region = "ap-southeast-2"
}
