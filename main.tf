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
    spacelift_aws_integration_attachment.read,
    spacelift_aws_integration_attachment.write,
    spacelift_context_attachment.this,
    spacelift_policy_attachment.this
  ]
  stack_id = spacelift_stack.this.id
}

# Triggers the stack after creation
resource "spacelift_run" "this" {
  stack_id = spacelift_stack.this.id
}

# ---------------------------------------------------------------------------
# AWS Integration – Read Role
#
# Spacelift uses this integration during plan (read-only) operations.
# The role ARN is constructed ahead of time to avoid a circular dependency
# between the IAM role and the trust-policy external ID.  The actual IAM
# role is created by the companion `modules/aws-integration` submodule.
# ---------------------------------------------------------------------------

resource "spacelift_aws_integration" "read" {
  count                          = var.setup_aws_integration ? 1 : 0
  name                           = "${var.spacelift_account_name}-${var.name}-read"
  role_arn                       = var.create_iam_role ? "arn:aws:iam::${var.aws_account_id}:role/${var.spacelift_account_name}-${var.name}-read" : var.read_execution_role_arn
  duration_seconds               = var.aws_integration_duration_seconds
  external_id                    = var.aws_integration_external_id
  generate_credentials_in_worker = var.aws_integration_generate_credentials_in_worker
  region                         = var.aws_integration_region

  lifecycle {
    precondition {
      condition     = !var.create_iam_role || var.aws_account_id != null
      error_message = "aws_account_id must be set when setup_aws_integration = true and create_iam_role = true."
    }
    precondition {
      condition     = var.create_iam_role || var.read_execution_role_arn != null
      error_message = "read_execution_role_arn must be set when setup_aws_integration = true and create_iam_role = false."
    }
  }
}

// Fetch the Spacelift-generated trust-policy statement for the read integration
// so the IAM role's trust relationship can be configured correctly in the
// aws-integration submodule.
data "spacelift_aws_integration_attachment_external_id" "read" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.read[0].id
  stack_id       = spacelift_stack.this.id
  read           = true
  write          = false
}

// Attaches the read AWS integration to the Spacelift stack.
// Role assumption is tested at attachment time; the IAM role must already
// exist (apply the aws-integration submodule before or alongside this module).
resource "spacelift_aws_integration_attachment" "read" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.read[0].id
  stack_id       = spacelift_stack.this.id
  read           = true
  write          = false
}

# ---------------------------------------------------------------------------
# AWS Integration – Write Role
#
# Spacelift uses this integration during apply (write) operations.
# ---------------------------------------------------------------------------

resource "spacelift_aws_integration" "write" {
  count                          = var.setup_aws_integration ? 1 : 0
  name                           = "${var.spacelift_account_name}-${var.name}-write"
  role_arn                       = var.create_iam_role ? "arn:aws:iam::${var.aws_account_id}:role/${var.spacelift_account_name}-${var.name}-write" : var.write_execution_role_arn
  duration_seconds               = var.aws_integration_duration_seconds
  external_id                    = var.aws_integration_external_id
  generate_credentials_in_worker = var.aws_integration_generate_credentials_in_worker
  region                         = var.aws_integration_region

  lifecycle {
    precondition {
      condition     = !var.create_iam_role || var.aws_account_id != null
      error_message = "aws_account_id must be set when setup_aws_integration = true and create_iam_role = true."
    }
    precondition {
      condition     = var.create_iam_role || var.write_execution_role_arn != null
      error_message = "write_execution_role_arn must be set when setup_aws_integration = true and create_iam_role = false."
    }
  }
}

// Fetch the Spacelift-generated trust-policy statement for the write integration.
data "spacelift_aws_integration_attachment_external_id" "write" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.write[0].id
  stack_id       = spacelift_stack.this.id
  read           = false
  write          = true
}

// Attaches the write AWS integration to the Spacelift stack.
resource "spacelift_aws_integration_attachment" "write" {
  count          = var.setup_aws_integration ? 1 : 0
  integration_id = spacelift_aws_integration.write[0].id
  stack_id       = spacelift_stack.this.id
  read           = false
  write          = true
}

# ---------------------------------------------------------------------------
# Stack Policy Attachments
# ---------------------------------------------------------------------------

# Attaches policies to the stack
resource "spacelift_policy_attachment" "this" {
  count     = length(var.attachment_policy_ids)
  policy_id = var.attachment_policy_ids[count.index]
  stack_id  = spacelift_stack.this.id
}

# ---------------------------------------------------------------------------
# Stack Context Attachments
# ---------------------------------------------------------------------------

# Attaches contexts to the stack
resource "spacelift_context_attachment" "this" {
  count      = length(var.attachment_context_ids)
  context_id = var.attachment_context_ids[count.index]
  stack_id   = spacelift_stack.this.id
  priority   = count.index
}
