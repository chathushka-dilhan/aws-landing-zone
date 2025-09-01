terraform {
  backend "s3" {
    bucket         = "org-terraform-remote-state" # Use the bucket created in _bootstrap
    key            = "management/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "org-terraform-state-locks"
    encrypt        = true
  }
}