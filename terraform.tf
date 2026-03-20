terraform {
  required_version = "~> 1.11.0"

  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 1.44.0"
    }
  }
}

provider "spacelift" {
  # Credentials can be passed as variables or via environment variables:
  #   SPACELIFT_API_KEY_ENDPOINT, SPACELIFT_API_KEY_ID, SPACELIFT_API_KEY_SECRET
  api_key_endpoint = coalesce(var.spacelift_api_key_endpoint, "https://${var.spacelift_account_name}.app.spacelift.io")
  api_key_id       = var.spacelift_api_key_id
  api_key_secret   = var.spacelift_api_key_secret
}
