# The id of the created stack
output "id" {
  description = "The ID of the created Spacelift stack."
  value       = spacelift_stack.this.id
}

# Trust-policy statement for the read (plan) IAM role.
# Feed this into the `modules/aws-integration` submodule as
# `read_assume_role_policy_statement`.
output "read_assume_role_policy_statement" {
  description = "AWS IAM assume-role policy statement for the read (plan) integration. Pass this to `modules/aws-integration` as `read_assume_role_policy_statement` when using Spacelift-managed IAM roles."
  value       = var.setup_aws_integration ? data.spacelift_aws_integration_attachment_external_id.read[0].assume_role_policy_statement : null
}

# Trust-policy statement for the write (apply) IAM role.
# Feed this into the `modules/aws-integration` submodule as
# `write_assume_role_policy_statement`.
output "write_assume_role_policy_statement" {
  description = "AWS IAM assume-role policy statement for the write (apply) integration. Pass this to `modules/aws-integration` as `write_assume_role_policy_statement` when using Spacelift-managed IAM roles."
  value       = var.setup_aws_integration ? data.spacelift_aws_integration_attachment_external_id.write[0].assume_role_policy_statement : null
}
