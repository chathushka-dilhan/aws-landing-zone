# Configuration for the AWS Management Account
# This account will manage the AWS Organization, IAM Identity Center, and central networking/security resources.

provider "aws" {
  region = var.aws_region
}

# Create the Organization Units (OUs) and apply basic SCPs
module "organization" {
  source = "../../modules/aws-organization"
  # No variables needed for this module's basic setup
}

# Create the central Permission Sets for IAM Identity Center
module "iam_identity_center" {
  source           = "../../modules/aws-iam-identity-center"
  sso_instance_arn = var.sso_instance_arn
}