# Configuration for the AWS Networking Account
# This account will host the Transit Gateway and manage network connectivity across the organization.

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${var.network_account_id}:role/CICD-Pipeline-Role"
  }
}

data "aws_organizations_organization" "main" {}

# Deploy the Transit Gateway hub
module "networking_hub" {
  source = "../../modules/aws-networking-hub"
}

# Share the Transit Gateway with the entire organization using AWS RAM
resource "aws_ram_resource_share" "tgw_share" {
  name                      = "Organization-Transit-Gateway-Share"
  allow_external_principals = false

  tags = {
    Name = "TGW-Share"
  }
}

resource "aws_ram_resource_association" "tgw_association" {
  resource_arn       = module.networking_hub.transit_gateway_arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}

resource "aws_ram_principal_association" "org_association" {
  principal          = data.aws_organizations_organization.main.arn
  resource_share_arn = aws_ram_resource_share.tgw_share.arn
}