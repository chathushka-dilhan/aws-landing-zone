# Configuration for the AWS Security Account
# This account will manage centralized security tooling like GuardDuty, Security Hub, and AWS Config.

data "aws_organizations_organization" "main" {}

# Deploy central logging bucket and organization-wide CloudTrail
module "logging" {
  source = "../../modules/aws-logging"
  providers = {
    aws          = aws.log_archive # Deploy S3 bucket in the log account
    aws.management = aws           # Deploy CloudTrail from the management account
  }

  organization_id = data.aws_organizations_organization.main.id
}

# Deploy GuardDuty and Security Hub, delegating to the security tooling account
module "security_tooling" {
  source    = "../../modules/aws-security-tooling"
  providers = {
    aws = aws.security_tooling
  }

  security_tooling_account_id = var.security_tooling_account_id
}