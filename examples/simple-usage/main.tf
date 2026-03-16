terraform {
  required_version = ">= 1.3.0"
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Basic Usage Example
# Spacelift provider credentials can be supplied as variables (shown below)
# or via environment variables: SPACELIFT_API_KEY_ENDPOINT,
# SPACELIFT_API_KEY_ID, SPACELIFT_API_KEY_SECRET
provider "spacelift" {}

provider "aws" {
  region = "us-east-1"
}

# Minimal example – uses github.com (default VCS) with managed state and
# automatic AWS integration via a newly created IAM role.
# See the root variables.tf for the full list of customisable inputs.
module "stack" {
  source = "../../"

  name                   = "example-stack"
  spacelift_account_name = "my-spacelift"
  repository_name        = "your-stack-repo"
  repository_branch      = "main"
  description            = "This is an example stack."

  # Optional: pin the Terraform version and workflow tool
  # terraform_version       = "1.6.0"
  # terraform_workflow_tool = "OPEN_TOFU"

  # Optional: enable autodeploy
  # autodeploy = true

  # Optional: attach policies and contexts
  # attachment_policy_ids  = ["my-policy-id"]
  # attachment_context_ids = ["my-context-id"]

  # Optional: use a GitHub Enterprise (custom app) VCS integration
  # github_organization = "my-org"

  # Optional: use GitLab as the VCS
  # gitlab = {
  #   namespace = "my-gitlab-group"
  # }

  # Optional: use Bitbucket Cloud as the VCS
  # bitbucket_cloud = {
  #   namespace = "MY_PROJECT"
  # }

  # Optional: deploy a Terragrunt stack
  # terragrunt = {
  #   terragrunt_version = "0.55.15"
  #   tool               = "OPEN_TOFU"
  #   use_run_all        = false
  # }
}
