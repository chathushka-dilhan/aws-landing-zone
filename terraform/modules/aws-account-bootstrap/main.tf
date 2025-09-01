# Creates foundational resources in a new AWS account
# Assumes that the AWS provider is already configured with appropriate permissions

# IAM Role to be assumed by the central management account's pipeline
resource "aws_iam_role" "cicd_role" {
  name = "CICD-Pipeline-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.management_account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Administrator policy to the role.
# In a real-world scenario, you might want to create a more restrictive policy.
resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.cicd_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create a budget to monitor costs in the account
resource "aws_budgets_budget" "account_budget" {
  name         = "Monthly-Account-Budget"
  budget_type  = "COST"
  limit_amount = var.budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.billing_alert_email]
  }
}