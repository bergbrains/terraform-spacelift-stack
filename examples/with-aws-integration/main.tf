# ---------------------------------------------------------------------------
# Create the Spacelift stack and AWS integrations (spacelift-only)
# ---------------------------------------------------------------------------

module "stack" {
  source = "../../"

  # Core stack settings
  name                   = var.name
  spacelift_account_name = var.spacelift_account_name
  repository_name        = var.repository_name
  repository_branch      = var.repository_branch
  description            = var.description

  # AWS integration settings – enable and supply the account ID so the module
  # can pre-construct the role ARNs before the IAM roles are created.
  setup_aws_integration = true
  create_iam_role       = true
  aws_account_id        = var.aws_account_id

  # Spacelift provider credentials (passed through to root module)
  spacelift_api_key_endpoint = var.spacelift_api_key_endpoint
  spacelift_api_key_id       = var.spacelift_api_key_id
  spacelift_api_key_secret   = var.spacelift_api_key_secret
}

# ---------------------------------------------------------------------------
# Create the read and write IAM roles in AWS (aws-only)
#
# The trust-policy statements produced by Step 1 are passed in so each role
# trusts the correct Spacelift integration's external ID.
# ---------------------------------------------------------------------------

module "aws_roles" {
  source = "../../modules/aws-integration"

  role_name_prefix = "${var.spacelift_account_name}-${var.name}"
  aws_region       = var.aws_region

  # Trust-policy statements wired from the stack module outputs
  read_assume_role_policy_statement  = module.stack.read_assume_role_policy_statement
  write_assume_role_policy_statement = module.stack.write_assume_role_policy_statement

  # Optional: customise attached policies
  # read_role_policy_arns  = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  # write_role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  tags = {
    StackName = var.name
    ManagedBy = "terraform"
  }
}
