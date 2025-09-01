# Configuration for the AWS Production Workloads Account
# This account will host production workloads and connect to the Transit Gateway in the networking account.

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.prod_account_id}:role/CICD-Pipeline-Role"
  }
}

# Read the output from the networking state file to get the TGW ID
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "org-terraform-remote-state"
    key    = "networking/terraform.tfstate"
    region = var.aws_region
  }
}

# Deploy a spoke VPC and attach it to the Transit Gateway
module "prod_vpc" {
  source = "../../../modules/aws-networking-spoke"

  environment          = "prod"
  vpc_cidr             = "10.10.0.0/16"
  private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnet_cidrs  = ["10.10.101.0/24", "10.10.102.0/24"]
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
  transit_gateway_id   = data.terraform_remote_state.networking.outputs.transit_gateway_id
}