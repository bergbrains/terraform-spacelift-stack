variable "aws_region" {
  type        = string
  description = "AWS region for the AWS provider."
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "The 12-digit AWS account ID. Used to pre-construct IAM role ARNs."
}

variable "name" {
  type        = string
  description = "The name of the Spacelift stack to create."
}

variable "spacelift_account_name" {
  type        = string
  description = "The name of the Spacelift account (e.g. the NAME in https://NAME.app.spacelift.io)."
}

variable "repository_name" {
  type        = string
  description = "The name of the Git repository for the stack."
}

variable "repository_branch" {
  type        = string
  description = "The Git branch to track."
  default     = "main"
}

variable "description" {
  type        = string
  description = "A free-form description of the Spacelift stack."
  default     = null
}

variable "spacelift_api_key_endpoint" {
  type        = string
  description = "The Spacelift API endpoint URL. Defaults to https://<spacelift_account_name>.app.spacelift.io."
  default     = null
}

variable "spacelift_api_key_id" {
  type        = string
  description = "The Spacelift API key ID."
  default     = null
  sensitive   = true
}

variable "spacelift_api_key_secret" {
  type        = string
  description = "The Spacelift API key secret."
  default     = null
  sensitive   = true
}
