# Create IAM Identity Center Permission Sets and attach managed policies
# This module assumes that the AWS provider is configured to use the management account.

resource "aws_ssoadmin_permission_set" "administrator_access" {
  name             = "AdministratorAccess"
  description      = "Provides full administrator access."
  instance_arn     = var.sso_instance_arn
  relay_state      = "https://console.aws.amazon.com/"
  session_duration = "PT8H" # 8 hours
}

resource "aws_ssoadmin_managed_policy_attachment" "admin_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_ssoadmin_permission_set" "view_only_access" {
  name             = "ViewOnlyAccess"
  description      = "Provides read-only access to services."
  instance_arn     = var.sso_instance_arn
  relay_state      = "https://console.aws.amazon.com/"
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "view_only_policy" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.view_only_access.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}