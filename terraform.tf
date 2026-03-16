terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  # AWS credentials are expected to be provided via environment variables,
  # shared credentials file, or IAM role
  region = var.aws_region
}

provider "spacelift" {
  # Credentials can be passed as variables or via environment variables:
  #   SPACELIFT_API_KEY_ENDPOINT, SPACELIFT_API_KEY_ID, SPACELIFT_API_KEY_SECRET
  api_key_endpoint = coalesce(var.spacelift_api_key_endpoint, "https://${var.spacelift_account_name}.app.spacelift.io")
  api_key_id       = var.spacelift_api_key_id
  api_key_secret   = var.spacelift_api_key_secret
}
