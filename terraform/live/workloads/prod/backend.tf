terraform {
  backend "s3" {
    bucket         = "org-terraform-remote-state"
    key            = "workloads/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "org-terraform-state-locks"
  }
}