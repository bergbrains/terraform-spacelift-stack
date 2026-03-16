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
<!-- END_TF_DOCS -->
