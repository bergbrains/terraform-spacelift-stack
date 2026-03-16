# with-aws-integration example

End-to-end example that creates a Spacelift stack **and** the corresponding
AWS IAM roles in a single `terraform apply`.

The configuration is split across two modules called from this root:

| Module | Provider | What it creates |
|--------|----------|-----------------|
| `../../` (root) | `spacelift` | Stack, integrations, destructor, initial run |
| `../../modules/aws-integration` | `aws` | Read IAM role, Write IAM role |

The trust-policy statements produced by the root module are threaded
directly into the AWS module inputs so each IAM role trusts the correct
Spacelift integration.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |
| <a name="requirement_spacelift"></a> [spacelift](#requirement\_spacelift) | >= 1.44.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_roles"></a> [aws\_roles](#module\_aws\_roles) | ../../modules/aws-integration | n/a |
| <a name="module_stack"></a> [stack](#module\_stack) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The 12-digit AWS account ID. Used to pre-construct IAM role ARNs. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region for the AWS provider. | `string` | `"us-east-1"` | no |
| <a name="input_description"></a> [description](#input\_description) | A free-form description of the Spacelift stack. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the Spacelift stack to create. | `string` | n/a | yes |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | The Git branch to track. | `string` | `"main"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | The name of the Git repository for the stack. | `string` | n/a | yes |
| <a name="input_spacelift_account_name"></a> [spacelift\_account\_name](#input\_spacelift\_account\_name) | The name of the Spacelift account (e.g. the NAME in https://NAME.app.spacelift.io). | `string` | n/a | yes |
| <a name="input_spacelift_api_key_endpoint"></a> [spacelift\_api\_key\_endpoint](#input\_spacelift\_api\_key\_endpoint) | The Spacelift API endpoint URL. Defaults to https://<spacelift\_account\_name>.app.spacelift.io. | `string` | `null` | no |
| <a name="input_spacelift_api_key_id"></a> [spacelift\_api\_key\_id](#input\_spacelift\_api\_key\_id) | The Spacelift API key ID. | `string` | `null` | no |
| <a name="input_spacelift_api_key_secret"></a> [spacelift\_api\_key\_secret](#input\_spacelift\_api\_key\_secret) | The Spacelift API key secret. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_read_role_arn"></a> [read\_role\_arn](#output\_read\_role\_arn) | ARN of the IAM role used by Spacelift for read (plan) operations. |
| <a name="output_stack_id"></a> [stack\_id](#output\_stack\_id) | The ID of the created Spacelift stack. |
| <a name="output_write_role_arn"></a> [write\_role\_arn](#output\_write\_role\_arn) | ARN of the IAM role used by Spacelift for write (apply) operations. |
<!-- END_TF_DOCS -->
