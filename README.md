<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.11.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.36.0 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | 1.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.36.0 |
| <a name="provider_spacelift"></a> [spacelift](#provider\_spacelift) | 1.44.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [spacelift_aws_role.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/aws_role) | resource |
| [spacelift_context_attachment.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/context_attachment) | resource |
| [spacelift_policy_attachment.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/policy_attachment) | resource |
| [spacelift_run.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/run) | resource |
| [spacelift_stack.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack) | resource |
| [spacelift_stack_destructor.this](https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/stack_destructor) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Spacelift stack to create. | `string` | n/a | yes |
| <a name="input_spacelift_account_name"></a> [spacelift\_account\_name](#input\_spacelift\_account\_name) | The name of the Spacelift account you are using. (e.g. The $NAME variable of https://$NAME.app.spacelift.io) | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the Git repository for the stack to use. | `string` | n/a | yes |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | The name of the branch to use for the specified Git repository. | `string` | n/a | yes |
| <a name="input_additional_project_globs"></a> [additional\_project\_globs](#input\_additional\_project\_globs) | Optional list of paths to track changes of in addition to the project root. | `set(string)` | `null` | no |
| <a name="input_administrative"></a> [administrative](#input\_administrative) | Deprecated: Whether or not the stack created should be administrative. Use `spacelift_role_attachment` resource instead. | `bool` | `false` | no |
| <a name="input_after_apply"></a> [after\_apply](#input\_after\_apply) | List of after-apply scripts. | `list(string)` | `[]` | no |
| <a name="input_after_destroy"></a> [after\_destroy](#input\_after\_destroy) | List of after-destroy scripts. | `list(string)` | `[]` | no |
| <a name="input_after_init"></a> [after\_init](#input\_after\_init) | List of after-init scripts. | `list(string)` | `[]` | no |
| <a name="input_after_perform"></a> [after\_perform](#input\_after\_perform) | List of after-perform scripts. | `list(string)` | `[]` | no |
| <a name="input_after_plan"></a> [after\_plan](#input\_after\_plan) | List of after-plan scripts. | `list(string)` | `[]` | no |
| <a name="input_after_run"></a> [after\_run](#input\_after\_run) | List of after-run scripts. | `list(string)` | `[]` | no |
| <a name="input_allow_run_promotion"></a> [allow\_run\_promotion](#input\_allow\_run\_promotion) | Indicates whether a proposed run can be promoted to a tracked run. Defaults to true. | `bool` | `true` | no |
| <a name="input_ansible"></a> [ansible](#input\_ansible) | Ansible-specific configuration. Presence means this stack is an Ansible stack. | <pre>object({<br/>  playbook = string<br/>})</pre> | `null` | no |
| <a name="input_attachment_context_ids"></a> [attachment\_context\_ids](#input\_attachment\_context\_ids) | A list of context IDs to attach in priority order. | `list(string)` | `[]` | no |
| <a name="input_attachment_policy_ids"></a> [attachment\_policy\_ids](#input\_attachment\_policy\_ids) | A list of policy IDs to attach to the stack being created. | `list(string)` | `[]` | no |
| <a name="input_autodeploy"></a> [autodeploy](#input\_autodeploy) | Whether or not the Spacelift stack created should autodeploy resources without approval. | `bool` | `false` | no |
| <a name="input_autoretry"></a> [autoretry](#input\_autoretry) | Indicates whether obsolete proposed changes should automatically be retried. | `bool` | `false` | no |
| <a name="input_aws_integration_duration_seconds"></a> [aws\_integration\_duration\_seconds](#input\_aws\_integration\_duration\_seconds) | AWS IAM role session duration in seconds for the Spacelift AWS integration. | `number` | `null` | no |
| <a name="input_aws_integration_external_id"></a> [aws\_integration\_external\_id](#input\_aws\_integration\_external\_id) | Custom external ID for the Spacelift AWS integration. Only works with private workers. | `string` | `null` | no |
| <a name="input_aws_integration_generate_credentials_in_worker"></a> [aws\_integration\_generate\_credentials\_in\_worker](#input\_aws\_integration\_generate\_credentials\_in\_worker) | Generate AWS credentials in the private worker instead of Spacelift. Requires a private worker pool. | `bool` | `false` | no |
| <a name="input_aws_integration_region"></a> [aws\_integration\_region](#input\_aws\_integration\_region) | AWS region to use for selecting a regional AWS STS endpoint in the Spacelift AWS integration. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to use for the AWS provider. | `string` | `"us-east-1"` | no |
| <a name="input_azure_devops"></a> [azure\_devops](#input\_azure\_devops) | Azure DevOps VCS settings. Provide to use Azure DevOps as the VCS for this stack. | <pre>object({<br/>  project = string<br/>  id      = optional(string)<br/>})</pre> | `null` | no |
| <a name="input_before_apply"></a> [before\_apply](#input\_before\_apply) | List of before-apply scripts. | `list(string)` | `[]` | no |
| <a name="input_before_destroy"></a> [before\_destroy](#input\_before\_destroy) | List of before-destroy scripts. | `list(string)` | `[]` | no |
| <a name="input_before_init"></a> [before\_init](#input\_before\_init) | List of before-init scripts. | `list(string)` | `[]` | no |
| <a name="input_before_perform"></a> [before\_perform](#input\_before\_perform) | List of before-perform scripts. | `list(string)` | `[]` | no |
| <a name="input_before_plan"></a> [before\_plan](#input\_before\_plan) | List of before-plan scripts. | `list(string)` | `[]` | no |
| <a name="input_bitbucket_cloud"></a> [bitbucket\_cloud](#input\_bitbucket\_cloud) | Bitbucket Cloud VCS settings. Provide to use Bitbucket Cloud as the VCS for this stack. | <pre>object({<br/>  namespace = string<br/>  id        = optional(string)<br/>})</pre> | `null` | no |
| <a name="input_bitbucket_datacenter"></a> [bitbucket\_datacenter](#input\_bitbucket\_datacenter) | Bitbucket Data Center VCS settings. Provide to use Bitbucket Data Center as the VCS for this stack. | <pre>object({<br/>  namespace = string<br/>  id        = optional(string)<br/>})</pre> | `null` | no |
| <a name="input_cloudformation"></a> [cloudformation](#input\_cloudformation) | CloudFormation-specific configuration. Presence means this stack is a CloudFormation stack. | <pre>object({<br/>  entry_template_file = string<br/>  region              = string<br/>  stack_name          = string<br/>  template_bucket     = string<br/>})</pre> | `null` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Whether or not to create an IAM role for the stack's AWS Integration. If false, `execution_role_arn` must be provided. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A free-form description of the Spacelift stack. | `string` | `null` | no |
| <a name="input_enable_local_preview"></a> [enable\_local\_preview](#input\_enable\_local\_preview) | Whether or not to enable the Spacelift CLI 'local preview' feature. | `bool` | `false` | no |
| <a name="input_enable_sensitive_outputs_upload"></a> [enable\_sensitive\_outputs\_upload](#input\_enable\_sensitive\_outputs\_upload) | Indicates whether sensitive outputs created by this stack can be uploaded to Spacelift for Stack Dependency references. | `bool` | `true` | no |
| <a name="input_enable_well_known_secret_masking"></a> [enable\_well\_known\_secret\_masking](#input\_enable\_well\_known\_secret\_masking) | Indicates whether well-known secret masking is enabled. | `bool` | `null` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | A custom IAM role ARN to use for the stack's AWS integration. Used when `create_iam_role` is false and `setup_aws_integration` is true. | `string` | `null` | no |
| <a name="input_execution_role_policy_arns"></a> [execution\_role\_policy\_arns](#input\_execution\_role\_policy\_arns) | A list of ARNs of IAM Policies to apply to the IAM Role used by the Spacelift stack AWS integration. | `list(string)` | <pre>[<br/>  "arn:aws:iam::aws:policy/PowerUserAccess"<br/>]</pre> | no |
| <a name="input_git_sparse_checkout_paths"></a> [git\_sparse\_checkout\_paths](#input\_git\_sparse\_checkout\_paths) | Git sparse checkout paths. If not set, the entire repository will be checked out. | `set(string)` | `null` | no |
| <a name="input_github_enterprise_id"></a> [github\_enterprise\_id](#input\_github\_enterprise\_id) | The ID of the GitHub Enterprise integration. If not set, the default integration will be used. | `string` | `null` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | For GitHub custom application (Enterprise) VCS users, specify the name of your GitHub Organization here. | `string` | `null` | no |
| <a name="input_gitlab"></a> [gitlab](#input\_gitlab) | GitLab VCS settings. Provide to use GitLab as the VCS for this stack. | <pre>object({<br/>  namespace = string<br/>  id        = optional(string)<br/>})</pre> | `null` | no |
| <a name="input_import_state"></a> [import\_state](#input\_import\_state) | State file content to upload when creating a new stack (sensitive). | `string` | `null` | no |
| <a name="input_import_state_file"></a> [import\_state\_file](#input\_import\_state\_file) | Path to a state file to upload when creating a new stack. | `string` | `null` | no |
| <a name="input_kubernetes"></a> [kubernetes](#input\_kubernetes) | Kubernetes-specific configuration. Presence means this stack is a Kubernetes stack. | <pre>object({<br/>  namespace                = optional(string)<br/>  kubectl_version          = optional(string)<br/>  kubernetes_workflow_tool = optional(string)<br/>})</pre> | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the stack being created. | `list(string)` | `[]` | no |
| <a name="input_manage_state"></a> [manage\_state](#input\_manage\_state) | Whether or not you would like Spacelift to manage the state for your stack. | `bool` | `true` | no |
| <a name="input_project_root"></a> [project\_root](#input\_project\_root) | The path to your project root in your repository to use as the root of the stack. Defaults to root of the repository. | `string` | `null` | no |
| <a name="input_protect_from_deletion"></a> [protect\_from\_deletion](#input\_protect\_from\_deletion) | Protect this stack from accidental deletion. If set, attempts to delete this stack will fail. | `bool` | `false` | no |
| <a name="input_pulumi"></a> [pulumi](#input\_pulumi) | Pulumi-specific configuration. Presence means this stack is a Pulumi stack. | <pre>object({<br/>  login_url  = string<br/>  stack_name = string<br/>})</pre> | `null` | no |
| <a name="input_raw_git"></a> [raw\_git](#input\_raw\_git) | Raw Git VCS settings for one-way integration using a plain HTTPS Git URL. | <pre>object({<br/>  namespace = string<br/>  url       = string<br/>})</pre> | `null` | no |
| <a name="input_runner_image"></a> [runner\_image](#input\_runner\_image) | Name of the Docker image used to process Runs. | `string` | `null` | no |
| <a name="input_setup_aws_integration"></a> [setup\_aws\_integration](#input\_setup\_aws\_integration) | Whether or not to setup the AWS integration for the Spacelift stack being created. | `bool` | `true` | no |
| <a name="input_slug"></a> [slug](#input\_slug) | Allows setting a custom ID (slug) for the stack. If not set, the stack ID is derived from the name. | `string` | `null` | no |
| <a name="input_space_id"></a> [space\_id](#input\_space\_id) | ID (slug) of the space the stack is in. Defaults to `legacy` if it exists, otherwise `root`. | `string` | `null` | no |
| <a name="input_spacelift_api_key_endpoint"></a> [spacelift\_api\_key\_endpoint](#input\_spacelift\_api\_key\_endpoint) | The Spacelift API endpoint URL. Defaults to https://\<spacelift\_account\_name\>.app.spacelift.io. Can also be set via SPACELIFT\_API\_KEY\_ENDPOINT. | `string` | `null` | no |
| <a name="input_spacelift_api_key_id"></a> [spacelift\_api\_key\_id](#input\_spacelift\_api\_key\_id) | The Spacelift API key ID. Can also be set via the SPACELIFT\_API\_KEY\_ID environment variable. | `string` | `null` | no |
| <a name="input_spacelift_api_key_secret"></a> [spacelift\_api\_key\_secret](#input\_spacelift\_api\_key\_secret) | The Spacelift API key secret. Can also be set via the SPACELIFT\_API\_KEY\_SECRET environment variable. | `string` | `null` | no |
| <a name="input_spacelift_aws_account_id"></a> [spacelift\_aws\_account\_id](#input\_spacelift\_aws\_account\_id) | The ID of Spacelift's AWS account used in the IAM assume-role trust policy. | `string` | `"324880187172"` | no |
| <a name="input_terraform_external_state_access"></a> [terraform\_external\_state\_access](#input\_terraform\_external\_state\_access) | Indicates whether you can access the stack state file from other stacks or outside of Spacelift. | `bool` | `false` | no |
| <a name="input_terraform_smart_sanitization"></a> [terraform\_smart\_sanitization](#input\_terraform\_smart\_sanitization) | Indicates whether runs will use Terraform's sensitive value system to sanitize outputs instead of sanitizing all fields. Requires Terraform >= 1.0.1. | `bool` | `false` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform for your stack to use. Defaults to latest if not set. | `string` | `null` | no |
| <a name="input_terraform_workflow_tool"></a> [terraform\_workflow\_tool](#input\_terraform\_workflow\_tool) | Defines the tool that will be used to execute the workflow. Valid values: `OPEN_TOFU`, `TERRAFORM_FOSS`, or `CUSTOM`. Defaults to `TERRAFORM_FOSS`. | `string` | `null` | no |
| <a name="input_terraform_workspace"></a> [terraform\_workspace](#input\_terraform\_workspace) | Terraform workspace to select when running plans and applies. | `string` | `null` | no |
| <a name="input_terragrunt"></a> [terragrunt](#input\_terragrunt) | Terragrunt-specific configuration. Presence means this stack is a Terragrunt stack. | <pre>object({<br/>  terraform_version      = optional(string)<br/>  terragrunt_version     = optional(string)<br/>  tool                   = optional(string)<br/>  use_run_all            = optional(bool)<br/>  use_smart_sanitization = optional(bool)<br/>  use_state_management   = optional(bool)<br/>})</pre> | `null` | no |
| <a name="input_worker_pool_id"></a> [worker\_pool\_id](#input\_worker\_pool\_id) | The ID of the worker pool to use for Spacelift stack runs. Required when using a self-hosted Spacelift instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_assume_role_policy_statement"></a> [aws\_assume\_role\_policy\_statement](#output\_aws\_assume\_role\_policy\_statement) | AWS IAM assume-role policy statement that sets up the trust relationship with Spacelift. Use this in your IAM role's trust policy when not using create\_iam\_role. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the created Spacelift stack. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role created for the Spacelift stack AWS integration. Null when create\_iam\_role is false. |
<!-- END_TF_DOCS -->
