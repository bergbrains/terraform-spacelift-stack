// ---------------------------------------------------------------------------
// Read IAM Role
// Used by Spacelift during plan (read-only) operations.
// ---------------------------------------------------------------------------

resource "aws_iam_role" "read" {
  count               = var.create_read_role ? 1 : 0
  name                = "${var.role_name_prefix}-read"
  managed_policy_arns = var.read_role_policy_arns

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      jsondecode(var.read_assume_role_policy_statement)
    ]
  })

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "spacelift-read"
  })
}

// ---------------------------------------------------------------------------
// Write IAM Role
// Used by Spacelift during apply (write) operations.
// ---------------------------------------------------------------------------

resource "aws_iam_role" "write" {
  count               = var.create_write_role ? 1 : 0
  name                = "${var.role_name_prefix}-write"
  managed_policy_arns = var.write_role_policy_arns

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      jsondecode(var.write_assume_role_policy_statement)
    ]
  })

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "spacelift-write"
  })
}
