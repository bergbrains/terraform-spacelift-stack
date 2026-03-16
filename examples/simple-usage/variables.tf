
variable "aws_region" {
  type        = string
  description = "The AWS region to use."
  default     = "us-east-1"
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
