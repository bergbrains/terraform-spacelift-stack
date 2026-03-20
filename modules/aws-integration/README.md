# modules/aws-integration

Creates the AWS IAM roles used by a Spacelift stack's read (plan) and write
(apply) integrations.

This module is the **AWS-only companion** to the root
`terraform-spacelift-stack` module. It owns every AWS resource so that the
root module can stay limited to the Spacelift provider, keeping each
Spacelift stack to a single cloud provider.

---

## Architecture

```
┌───────────────────────────────────────────────────────────┐
│  Root module  (spacelift provider only)                   │
│                                                           │
│  spacelift_stack  ──►  spacelift_aws_integration (read)   │
│                   └──►  spacelift_aws_integration (write)  │
│                                                           │
│  Outputs: read_assume_role_policy_statement               │
│           write_assume_role_policy_statement              │
└──────────────────────────┬────────────────────────────────┘
                           │  wire outputs → inputs
┌──────────────────────────▼────────────────────────────────┐
│  modules/aws-integration  (aws provider only)             │
│                                                           │
│  aws_iam_role.read   ← read_assume_role_policy_statement  │
│  aws_iam_role.write  ← write_assume_role_policy_statement │
└───────────────────────────────────────────────────────────┘
```

**Why two roles?**

| Role  | Used for              | Default policy         |
|-------|-----------------------|------------------------|
| read  | `terraform plan`      | `ReadOnlyAccess`       |
| write | `terraform apply`     | `PowerUserAccess`      |

Separate roles let you enforce least-privilege: Spacelift uses the
read role when it only needs to preview changes and the write role
when it needs to make them.

---

## Usage

> **Prerequisites** – Apply the root module first (or in the same Terraform
> configuration) to obtain the trust-policy statements. The statements
> are stack+integration-specific and must come from the root module outputs.

### Standalone (applied separately)

```hcl
module "aws_roles" {
  source = "bergbrains/terraform-spacelift-stack//modules/aws-integration"

  role_name_prefix = "my-spacelift-account-my-stack"
  aws_region       = "us-east-1"

  # Wired from the root module outputs
  read_assume_role_policy_statement  = "<json string from root module>"
  write_assume_role_policy_statement = "<json string from root module>"
}
```

### Inline with the root module (recommended)

See the full wiring example in
[`examples/with-aws-integration`](../../examples/with-aws-integration/).

```hcl
module "stack" {
  source = "bergbrains/terraform-spacelift-stack"
  # ... stack variables ...
  setup_aws_integration = true
  create_iam_role       = true
  aws_account_id        = "123456789012"
}

module "aws_roles" {
  source = "bergbrains/terraform-spacelift-stack//modules/aws-integration"

  role_name_prefix = "my-spacelift-account-my-stack"
  aws_region       = "us-east-1"

  read_assume_role_policy_statement  = module.stack.read_assume_role_policy_statement
  write_assume_role_policy_statement = module.stack.write_assume_role_policy_statement
}
```

---

## Applying in the correct order

Because the Spacelift integration attachment tests role assumption at creation
time, the IAM roles **must exist before** the integration attachments are
created. When both modules are declared in the same Terraform configuration
(as in the example above), Terraform resolves the dependency automatically
via the output/input chain.

If you apply the modules in separate configurations:

1. Apply the root module **without** attachments (or accept the initial
   attachment failure and re-apply after step 2).
2. Apply `modules/aws-integration` to create the IAM roles.
3. Re-apply the root module; the attachments will now succeed.

---

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
