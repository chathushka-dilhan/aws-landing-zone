terraform {
  backend "s3" {
    bucket         = "org-terraform-remote-state"
    key            = "security/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "org-terraform-state-locks"
  }
}