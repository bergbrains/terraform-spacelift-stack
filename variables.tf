variable "name" {
  type        = string
  description = "The name of the Spacelift stack to create."
}

variable "slug" {
  type        = string
  description = "Allows setting a custom ID (slug) for the stack. If not set, the stack ID is derived from the name."
  default     = null
}

variable "space_id" {
  type        = string
  description = "ID (slug) of the space the stack is in. Defaults to `legacy` if it exists, otherwise `root`."
  default     = null
}

variable "spacelift_account_name" {
  type        = string
  description = "The name of the Spacelift account you are using. (e.g. The $NAME variable of https://$NAME.app.spacelift.io)"
}

variable "repository_name" {
  type        = string
  description = "The name of the Git repository for the stack to use."
}

variable "repository_branch" {
  type        = string
  description = "The name of the branch to use for the specified Git repository."
}

variable "manage_state" {
  type        = bool
  description = "Whether or not you would like Spacelift to manage the state for your stack."
  default     = true
}

variable "description" {
  type        = string
  description = "A free-form description of the Spacelift stack."
  default     = null
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform for your stack to use. Defaults to latest if not set."
  default     = null
}

variable "terraform_workflow_tool" {
  type        = string
  description = "Defines the tool that will be used to execute the workflow. Valid values: `OPEN_TOFU`, `TERRAFORM_FOSS`, or `CUSTOM`. Defaults to `TERRAFORM_FOSS`."
  default     = null
}

variable "terraform_workspace" {
  type        = string
  description = "Terraform workspace to select when running plans and applies."
  default     = null
}

variable "terraform_smart_sanitization" {
  type        = bool
  description = "Indicates whether runs will use Terraform's sensitive value system to sanitize outputs of Terraform state and plans in Spacelift instead of sanitizing all fields. Requires Terraform >= 1.0.1."
  default     = false
}

variable "terraform_external_state_access" {
  type        = bool
  description = "Indicates whether you can access the stack state file from other stacks or outside of Spacelift."
  default     = false
}

variable "enable_local_preview" {
  type        = bool
  description = "Whether or not to enable the Spacelift CLI 'local preview' feature."
  default     = false
}

variable "enable_sensitive_outputs_upload" {
  type        = bool
  description = "Indicates whether sensitive outputs created by this stack can be uploaded to Spacelift to be used by Stack Dependency references."
  default     = true
}

variable "enable_well_known_secret_masking" {
  type        = bool
  description = "Indicates whether well-known secret masking is enabled."
  default     = null
}

variable "worker_pool_id" {
  type        = string
  description = "The ID of the worker pool to use for Spacelift stack runs. Required when using a self-hosted Spacelift instance."
  default     = null
}

variable "administrative" {
  type        = bool
  description = "Deprecated: Whether or not the stack created should be administrative. Use `spacelift_role_attachment` resource instead."
  default     = false
}

variable "autodeploy" {
  type        = bool
  description = "Whether or not the Spacelift stack created should autodeploy resources without approval."
  default     = false
}

variable "allow_run_promotion" {
  type        = bool
  description = "Indicates whether a proposed run can be promoted to a tracked run. Defaults to true."
  default     = true
}

variable "protect_from_deletion" {
  type        = bool
  description = "Protect this stack from accidental deletion. If set, attempts to delete this stack will fail."
  default     = false
}

variable "project_root" {
  type        = string
  description = "The path to your project root in your repository to use as the root of the stack. Defaults to root of the repository."
  default     = null
}

variable "additional_project_globs" {
  type        = set(string)
  description = "Optional list of paths to track changes of in addition to the project root."
  default     = null
}

variable "git_sparse_checkout_paths" {
  type        = set(string)
  description = "Git sparse checkout paths. If not set, the entire repository will be checked out."
  default     = null
}

variable "labels" {
  type        = list(string)
  description = "Labels to apply to the stack being created."
  default     = []
}

variable "import_state" {
  type        = string
  description = "State file content to upload when creating a new stack (sensitive)."
  default     = null
  sensitive   = true
}

variable "import_state_file" {
  type        = string
  description = "Path to a state file to upload when creating a new stack."
  default     = null
}

# ---------------------------------------------------------------------------
# AWS Integration
# ---------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "The AWS region to use for the AWS provider."
  default     = "us-east-1"
}


variable "execution_role_policy_arns" {
  type        = list(string)
  description = "A list of ARNs of IAM Policies to apply to the IAM Role used by the Spacelift stack AWS integration."
  default = [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ]
}

variable "setup_aws_integration" {
  type        = bool
  description = "Whether or not to setup the AWS integration for the Spacelift stack being created."
  default     = true
}

variable "create_iam_role" {
  type        = bool
  description = "Whether or not to create an IAM role for the stack's AWS Integration. If false, `execution_role_arn` must be provided."
  default     = true
}

variable "execution_role_arn" {
  type        = string
  description = "A custom IAM role ARN to use for the stack's AWS integration. Used when `create_iam_role` is false and `setup_aws_integration` is true."
  default     = null
}

variable "aws_integration_read" {
  type        = bool
  description = "Indicates whether the AWS integration attachment is used for read operations."
  default     = true
}

variable "aws_integration_write" {
  type        = bool
  description = "Indicates whether the AWS integration attachment is used for write operations."
  default     = true
}

variable "aws_integration_duration_seconds" {
  type        = number
  description = "AWS IAM role session duration in seconds for the Spacelift AWS integration."
  default     = null
}

variable "aws_integration_external_id" {
  type        = string
  description = "Custom external ID for the Spacelift AWS integration. Only works with private workers."
  default     = null
}

variable "aws_integration_generate_credentials_in_worker" {
  type        = bool
  description = "Generate AWS credentials in the private worker instead of Spacelift. Requires a private worker pool."
  default     = false
}

variable "aws_integration_region" {
  type        = string
  description = "AWS region to use for selecting a regional AWS STS endpoint in the Spacelift AWS integration."
  default     = null
}

# ---------------------------------------------------------------------------
# Attachments
# ---------------------------------------------------------------------------

variable "attachment_policy_ids" {
  type        = list(string)
  description = "A list of policy IDs to attach to the stack being created."
  default     = []
}

variable "attachment_context_ids" {
  type        = list(string)
  description = "A list of context IDs to attach in priority order."
  default     = []
}

# ---------------------------------------------------------------------------
# Runner / image
# ---------------------------------------------------------------------------

variable "runner_image" {
  type        = string
  description = "Name of the Docker image used to process Runs."
  default     = null
}

variable "autoretry" {
  type        = bool
  description = "Indicates whether obsolete proposed changes should automatically be retried."
  default     = false
}

# ---------------------------------------------------------------------------
# Lifecycle hooks
# ---------------------------------------------------------------------------

variable "before_apply" {
  type        = list(string)
  description = "List of before-apply scripts."
  default     = []
}

variable "before_destroy" {
  type        = list(string)
  description = "List of before-destroy scripts."
  default     = []
}

variable "before_init" {
  type        = list(string)
  description = "List of before-init scripts."
  default     = []
}

variable "before_perform" {
  type        = list(string)
  description = "List of before-perform scripts."
  default     = []
}

variable "before_plan" {
  type        = list(string)
  description = "List of before-plan scripts."
  default     = []
}

variable "after_apply" {
  type        = list(string)
  description = "List of after-apply scripts."
  default     = []
}

variable "after_destroy" {
  type        = list(string)
  description = "List of after-destroy scripts."
  default     = []
}

variable "after_init" {
  type        = list(string)
  description = "List of after-init scripts."
  default     = []
}

variable "after_perform" {
  type        = list(string)
  description = "List of after-perform scripts."
  default     = []
}

variable "after_plan" {
  type        = list(string)
  description = "List of after-plan scripts."
  default     = []
}

variable "after_run" {
  type        = list(string)
  description = "List of after-run scripts."
  default     = []
}

# ---------------------------------------------------------------------------
# VCS Integrations
# ---------------------------------------------------------------------------

variable "github_organization" {
  type        = string
  description = "For GitHub custom application (Enterprise) VCS users, specify the name of your GitHub Organization here."
  default     = null
}

variable "github_enterprise_id" {
  type        = string
  description = "The ID of the GitHub Enterprise integration. If not set, the default integration will be used."
  default     = null
}

variable "azure_devops" {
  type = object({
    project = string
    id      = optional(string)
  })
  description = "Azure DevOps VCS settings. Provide to use Azure DevOps as the VCS for this stack."
  default     = null
}

variable "bitbucket_cloud" {
  type = object({
    namespace = string
    id        = optional(string)
  })
  description = "Bitbucket Cloud VCS settings. Provide to use Bitbucket Cloud as the VCS for this stack."
  default     = null
}

variable "bitbucket_datacenter" {
  type = object({
    namespace = string
    id        = optional(string)
  })
  description = "Bitbucket Data Center VCS settings. Provide to use Bitbucket Data Center as the VCS for this stack."
  default     = null
}

variable "gitlab" {
  type = object({
    namespace = string
    id        = optional(string)
  })
  description = "GitLab VCS settings. Provide to use GitLab as the VCS for this stack."
  default     = null
}

variable "raw_git" {
  type = object({
    namespace = string
    url       = string
  })
  description = "Raw Git VCS settings for one-way integration using a plain HTTPS Git URL."
  default     = null
}

# ---------------------------------------------------------------------------
# Stack Types (IaC tool-specific configuration)
# ---------------------------------------------------------------------------

variable "ansible" {
  type = object({
    playbook = string
  })
  description = "Ansible-specific configuration. Presence means this stack is an Ansible stack."
  default     = null
}

variable "cloudformation" {
  type = object({
    entry_template_file = string
    region              = string
    stack_name          = string
    template_bucket     = string
  })
  description = "CloudFormation-specific configuration. Presence means this stack is a CloudFormation stack."
  default     = null
}

variable "kubernetes" {
  type = object({
    namespace                = optional(string)
    kubectl_version          = optional(string)
    kubernetes_workflow_tool = optional(string)
  })
  description = "Kubernetes-specific configuration. Presence means this stack is a Kubernetes stack."
  default     = null
}

variable "pulumi" {
  type = object({
    login_url  = string
    stack_name = string
  })
  description = "Pulumi-specific configuration. Presence means this stack is a Pulumi stack."
  default     = null
}

variable "terragrunt" {
  type = object({
    terraform_version      = optional(string)
    terragrunt_version     = optional(string)
    tool                   = optional(string)
    use_run_all            = optional(bool)
    use_smart_sanitization = optional(bool)
    use_state_management   = optional(bool)
  })
  description = "Terragrunt-specific configuration. Presence means this stack is a Terragrunt stack."
  default     = null
}

# ---------------------------------------------------------------------------
# Spacelift Provider Credentials
# ---------------------------------------------------------------------------

variable "spacelift_api_key_endpoint" {
  type        = string
  description = "The Spacelift API endpoint URL. Defaults to https://<spacelift_account_name>.app.spacelift.io. Can also be set via the SPACELIFT_API_KEY_ENDPOINT environment variable."
  default     = null
}

variable "spacelift_api_key_id" {
  type        = string
  description = "The Spacelift API key ID. Can also be set via the SPACELIFT_API_KEY_ID environment variable."
  default     = null
  sensitive   = true
}

variable "spacelift_api_key_secret" {
  type        = string
  description = "The Spacelift API key secret. Can also be set via the SPACELIFT_API_KEY_SECRET environment variable."
  default     = null
  sensitive   = true
}
