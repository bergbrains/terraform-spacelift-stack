output "stack_id" {
  description = "The ID of the created Spacelift stack."
  value       = module.stack.id
}

output "read_role_arn" {
  description = "ARN of the IAM role used by Spacelift for read (plan) operations."
  value       = module.aws_roles.read_role_arn
}

output "write_role_arn" {
  description = "ARN of the IAM role used by Spacelift for write (apply) operations."
  value       = module.aws_roles.write_role_arn
}
