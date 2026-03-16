terraform {
  required_version = "~> 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 1.44.0"
    }
  }
}

provider "aws" {
  # AWS credentials are expected to be provided via environment variables,
  # shared credentials file, or IAM role
  region = var.aws_region
}

provider "spacelift" {
  api_key_endpoint = "https://my-spacelift.app.spacelift.io"
  api_key_id       = "" # your-spacelift-api-key-id
  api_key_secret   = "" # your-spacelift-api-key-secret
}
