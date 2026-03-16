resource "spacelift_stack" "this" {
  name        = var.name
  slug        = var.slug
  space_id    = var.space_id
  repository  = var.repository_name
  branch      = var.repository_branch
  description = var.description

  # State management
  manage_state = var.manage_state

  # Terraform-specific settings
  terraform_version               = var.terraform_version
  terraform_workflow_tool         = var.terraform_workflow_tool
  terraform_workspace             = var.terraform_workspace
  terraform_smart_sanitization    = var.terraform_smart_sanitization
  terraform_external_state_access = var.terraform_external_state_access

  # Stack behaviour
  administrative                   = var.administrative
  autodeploy                       = var.autodeploy
  autoretry                        = var.autoretry
  allow_run_promotion              = var.allow_run_promotion
  protect_from_deletion            = var.protect_from_deletion
  enable_local_preview             = var.enable_local_preview
  enable_sensitive_outputs_upload  = var.enable_sensitive_outputs_upload
  enable_well_known_secret_masking = var.enable_well_known_secret_masking

  # Execution environment
  worker_pool_id = var.worker_pool_id
  runner_image   = var.runner_image
  project_root   = var.project_root
  labels         = var.labels

  # Repository path tracking
  additional_project_globs  = var.additional_project_globs
  git_sparse_checkout_paths = var.git_sparse_checkout_paths

  # State import
  import_state      = var.import_state
  import_state_file = var.import_state_file

  # Lifecycle hooks
  before_init    = var.before_init
  before_plan    = var.before_plan
  before_apply   = var.before_apply
  before_perform = var.before_perform
  before_destroy = var.before_destroy
  after_init     = var.after_init
  after_plan     = var.after_plan
  after_apply    = var.after_apply
  after_perform  = var.after_perform
  after_destroy  = var.after_destroy
  after_run      = var.after_run

  # ---------------------------------------------------------------------------
  # VCS Integrations (mutually exclusive – configure at most one)
  # ---------------------------------------------------------------------------

  dynamic "github_enterprise" {
    for_each = var.github_organization != null ? [true] : []
    content {
      namespace = var.github_organization
      id        = var.github_enterprise_id
    }
  }

  dynamic "azure_devops" {
    for_each = var.azure_devops != null ? [var.azure_devops] : []
    content {
      project = azure_devops.value.project
      id      = azure_devops.value.id
    }
  }

  dynamic "bitbucket_cloud" {
    for_each = var.bitbucket_cloud != null ? [var.bitbucket_cloud] : []
    content {
      namespace = bitbucket_cloud.value.namespace
      id        = bitbucket_cloud.value.id
    }
  }

  dynamic "bitbucket_datacenter" {
    for_each = var.bitbucket_datacenter != null ? [var.bitbucket_datacenter] : []
    content {
      namespace = bitbucket_datacenter.value.namespace
      id        = bitbucket_datacenter.value.id
    }
  }

  dynamic "gitlab" {
    for_each = var.gitlab != null ? [var.gitlab] : []
    content {
      namespace = gitlab.value.namespace
      id        = gitlab.value.id
    }
  }

  dynamic "raw_git" {
    for_each = var.raw_git != null ? [var.raw_git] : []
    content {
      namespace = raw_git.value.namespace
      url       = raw_git.value.url
    }
  }

  # ---------------------------------------------------------------------------
  # Stack Types (IaC tool-specific – mutually exclusive with each other and
  # with `terraform_version` / `terraform_workflow_tool`)
  # ---------------------------------------------------------------------------

  dynamic "ansible" {
    for_each = var.ansible != null ? [var.ansible] : []
    content {
      playbook = ansible.value.playbook
    }
  }

  dynamic "cloudformation" {
    for_each = var.cloudformation != null ? [var.cloudformation] : []
    content {
      entry_template_file = cloudformation.value.entry_template_file
      region              = cloudformation.value.region
      stack_name          = cloudformation.value.stack_name
      template_bucket     = cloudformation.value.template_bucket
    }
  }

  dynamic "kubernetes" {
    for_each = var.kubernetes != null ? [var.kubernetes] : []
    content {
      namespace                = kubernetes.value.namespace
      kubectl_version          = kubernetes.value.kubectl_version
      kubernetes_workflow_tool = kubernetes.value.kubernetes_workflow_tool
    }
  }

  dynamic "pulumi" {
    for_each = var.pulumi != null ? [var.pulumi] : []
    content {
      login_url  = pulumi.value.login_url
      stack_name = pulumi.value.stack_name
    }
  }

  dynamic "terragrunt" {
    for_each = var.terragrunt != null ? [var.terragrunt] : []
    content {
      terraform_version      = terragrunt.value.terraform_version
      terragrunt_version     = terragrunt.value.terragrunt_version
      tool                   = terragrunt.value.tool
      use_run_all            = terragrunt.value.use_run_all
      use_smart_sanitization = terragrunt.value.use_smart_sanitization
      use_state_management   = terragrunt.value.use_state_management
    }
  }
}

# Used to trigger the deletion of resources when a stack is destroyed
resource "spacelift_stack_destructor" "this" {
  depends_on = [
    spacelift_stack.this,
    spacelift_aws_integration_attachment.this,
    spacelift_context_attachment.this,
    spacelift_policy_attachment.this
  ]
  stack_id = spacelift_stack.this.id
}

# Triggers the stack after creation
resource "spacelift_run" "this" {
  stack_id = spacelift_stack.this.id
}

// Retrieve the current AWS account ID to construct the IAM role ARN ahead of
// time (avoids a circular dependency between the role and the integration).
// Only needed when we are creating the IAM role and the Spacelift integration.
data "aws_caller_identity" "current" {
  count = var.create_iam_role && var.setup_aws_integration ? 1 : 0
}

// Account-level AWS integration (replaces the deprecated spacelift_aws_role).
// This integration can be reused across multiple stacks via attachments.
//
// NOTE: The role_arn is constructed from the caller's account ID rather than
// referencing aws_iam_role.this directly. This is intentional: the integration
// must exist first so that `spacelift_aws_integration_attachment_external_id`
// can generate the correct trust-policy external ID used by the IAM role.
// Role assumption is only tested at attachment time, by which point the IAM
// role has already been created (see `depends_on` on the attachment resource).
resource "spacelift_aws_integration" "this" {
  count                          = var.setup_aws_integration ? 1 : 0
  name                           = "${var.spacelift_account_name}-${var.name}"
  role_arn                       = var.create_iam_role ? "arn:aws:iam::${data.aws_caller_identity.current[0].account_id}:role/${var.spacelift_account_name}-${var.name}" : var.execution_role_arn
  duration_seconds               = var.aws_integration_duration_seconds
  external_id                    = var.aws_integration_external_id
  generate_credentials_in_worker = var.aws_integration_generate_credentials_in_worker
  region                         = var.aws_integration_region
}

// Fetch the Spacelift-generated trust-policy statement for this
// integration+stack pair so the IAM role's trust relationship is correct.
// Also exposed via the `aws_assume_role_policy_statement` output for BYO-role
// scenarios where create_iam_role = false.
data "spacelift_aws_integration_attachment_external_id" "this" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.this[0].id
  stack_id       = spacelift_stack.this.id
  read           = var.aws_integration_read
  write          = var.aws_integration_write
}

// IAM Role to allow stacks to deploy resources on AWS
resource "aws_iam_role" "this" {
  count               = var.create_iam_role ? 1 : 0
  name                = "${var.spacelift_account_name}-${var.name}"
  managed_policy_arns = var.execution_role_policy_arns
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      jsondecode(data.spacelift_aws_integration_attachment_external_id.this[0].assume_role_policy_statement)
    ]
  })
}

// Attaches the AWS integration to the Spacelift stack
resource "spacelift_aws_integration_attachment" "this" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.this[0].id
  stack_id       = spacelift_stack.this.id
  read           = var.aws_integration_read
  write          = var.aws_integration_write

  # The role must exist before attaching since Spacelift tests role assumption
  depends_on = [aws_iam_role.this]
}

// Stack Policy Attachments
# Attaches policies to the stack
resource "spacelift_policy_attachment" "this" {
  count     = length(var.attachment_policy_ids)
  policy_id = var.attachment_policy_ids[count.index]
  stack_id  = spacelift_stack.this.id
}

// Stack Context Attachments
# Attaches contexts to the stack
resource "spacelift_context_attachment" "this" {
  count      = length(var.attachment_context_ids)
  context_id = var.attachment_context_ids[count.index]
  stack_id   = spacelift_stack.this.id
  priority   = count.index
}
