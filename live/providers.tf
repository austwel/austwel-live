provider "aws" {
  region  = local.aws_region

  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
}

provider "cloudflare" {}

locals {
  # Sydney
  aws_region = "ap-southeast-2"
}
