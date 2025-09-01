# Create GuardDuty and Security Hub resources for the AWS Organization
# This module assumes that the AWS provider is configured to use the management account.

# Enable GuardDuty for the organization
resource "aws_guardduty_detector" "main" {
  enable = true
}

resource "aws_guardduty_organization_admin_account" "main" {
  admin_account_id = var.security_tooling_account_id
}

# Enable AWS Security Hub for the organization
resource "aws_securityhub_account" "main" {}

resource "aws_securityhub_organization_admin_account" "main" {
  admin_account_id = var.security_tooling_account_id
}