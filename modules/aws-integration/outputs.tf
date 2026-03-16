output "read_role_arn" {
  description = "ARN of the IAM role used by Spacelift for read (plan) operations. Null when create_read_role is false."
  value       = var.create_read_role ? aws_iam_role.read[0].arn : null
}

output "write_role_arn" {
  description = "ARN of the IAM role used by Spacelift for write (apply) operations. Null when create_write_role is false."
  value       = var.create_write_role ? aws_iam_role.write[0].arn : null
}
