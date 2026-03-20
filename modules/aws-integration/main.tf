locals {
  # ---------------------------------------------------------------------------
  # Parse the Spacelift-provided trust-policy statements.
  # `assume_role_policy_statement` from `spacelift_aws_integration_attachment_external_id`
  # is a single JSON statement (not a full policy document):
  #   {
  #     "Effect": "Allow",
  #     "Principal": { "AWS": "arn:aws:iam::<spacelift-account-id>:root" },
  #     "Action": ["sts:AssumeRole", "sts:TagSession"],
  #     "Condition": { "StringEquals": { "sts:ExternalId": "<id>" } }
  #   }
  # ---------------------------------------------------------------------------

  read_stmt  = jsondecode(var.read_assume_role_policy_statement)
  write_stmt = jsondecode(var.write_assume_role_policy_statement)

  # Normalise the Spacelift-generated external ID(s) to a list.
  # The value in the JSON statement may be a plain string or a JSON array.
  read_spacelift_ids = try(
    tolist(local.read_stmt.Condition.StringEquals["sts:ExternalId"]),
    [tostring(local.read_stmt.Condition.StringEquals["sts:ExternalId"])]
  )
  write_spacelift_ids = try(
    tolist(local.write_stmt.Condition.StringEquals["sts:ExternalId"]),
    [tostring(local.write_stmt.Condition.StringEquals["sts:ExternalId"])]
  )

  # Merge Spacelift-generated IDs with any caller-supplied additional IDs.
  read_all_external_ids  = concat(local.read_spacelift_ids, var.read_additional_external_ids)
  write_all_external_ids = concat(local.write_spacelift_ids, var.write_additional_external_ids)
}

// ---------------------------------------------------------------------------
// Read IAM Role
// Used by Spacelift during plan (read-only) operations.
// ---------------------------------------------------------------------------

resource "aws_iam_role" "read" {
  count               = var.create_read_role ? 1 : 0
  name                = "${var.role_name_prefix}-read"
  managed_policy_arns = var.read_role_policy_arns

  # Build the complete STS trust policy from the parsed Spacelift statement
  # components. External IDs are merged: Spacelift-generated + additional.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = local.read_stmt.Principal
        Action    = local.read_stmt.Action
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.read_all_external_ids
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "spacelift-read"
    role      = "read"
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

  # Build the complete STS trust policy from the parsed Spacelift statement
  # components. External IDs are merged: Spacelift-generated + additional.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = local.write_stmt.Principal
        Action    = local.write_stmt.Action
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.write_all_external_ids
          }
        }
      }
    ]
  })

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Purpose   = "spacelift-write"
    role      = "write"
  })
}
