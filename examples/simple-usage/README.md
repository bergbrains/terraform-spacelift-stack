# simple-usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | ~> 0.1.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_stack"></a> [stack](#module\_stack) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Spacelift stack to create. | `string` | n/a | yes |
| <a name="input_spacelift_account_name"></a> [spacelift\_account\_name](#input\_spacelift\_account\_name) | The name of the Spacelift account (e.g. the NAME in https://NAME.app.spacelift.io). | `string` | n/a | yes |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the Git repository for the stack. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to use. | `string` | `"us-east-1"` | no |
| <a name="input_description"></a> [description](#input\_description) | A free-form description of the Spacelift stack. | `string` | `null` | no |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | The Git branch to track. | `string` | `"main"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
