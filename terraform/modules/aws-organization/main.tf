# Creates the AWS Organization
# Assumes that the AWS provider is already configured with appropriate permissions

# Enables Service Control Policies (SCPs) for the Organization
resource "aws_organizations_policy_attachment" "scp_enable" {
  policy_id = "p-FullAWSAccess"
  target_id = aws_organizations_organization.main.root[0].id
}

# Creates the primary Organizational Units (OUs)
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.main.root[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = aws_organizations_organization.main.root[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.main.root[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.main.root[0].id
}

# Example SCP: Prevent member accounts from leaving the organization
resource "aws_organizations_policy" "prevent_leave" {
  name        = "PreventLeaveOrganization"
  description = "Prevents member accounts from leaving the organization."
  content = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Deny",
        Action   = "organizations:LeaveOrganization",
        Resource = "*"
      }
    ]
  })
}

# Attach the SCP to the Root of the organization
resource "aws_organizations_policy_attachment" "prevent_leave_attachment" {
  policy_id = aws_organizations_policy.prevent_leave.id
  target_id = aws_organizations_organization.main.root[0].id
}