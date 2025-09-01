provider "aws" {
  # Default provider for the management account to read organization data
  region = var.aws_region
}

provider "aws" {
  alias  = "log_archive"
  region = var.aws_region
  assume_role {
    # Assumes the role created by the aws-account-bootstrap module
    role_arn = "arn:aws:iam::${var.log_archive_account_id}:role/CICD-Pipeline-Role"
  }
}

provider "aws" {
  alias  = "security_tooling"
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.security_tooling_account_id}:role/CICD-Pipeline-Role"
  }
}