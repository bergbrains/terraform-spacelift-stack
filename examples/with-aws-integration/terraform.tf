terraform {
  required_version = ">= 1.11.5"
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 1.44.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Provider configuration
# ---------------------------------------------------------------------------

# Spacelift credentials can be supplied as variables (shown below) or via
# environment variables: SPACELIFT_API_KEY_ENDPOINT, SPACELIFT_API_KEY_ID,
# SPACELIFT_API_KEY_SECRET
provider "spacelift" {
  api_key_endpoint = coalesce(var.spacelift_api_key_endpoint, "https://${var.spacelift_account_name}.app.spacelift.io")
  api_key_id       = var.spacelift_api_key_id
  api_key_secret   = var.spacelift_api_key_secret
}

# AWS credentials should be supplied via environment variables, shared
# credentials file, or an IAM instance profile.
provider "aws" {
  region = var.aws_region
}
