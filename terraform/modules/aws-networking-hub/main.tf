# Create a central AWS Transit Gateway for the organization
# This module assumes that the AWS provider is configured to use the management account.

resource "aws_ec2_transit_gateway" "hub" {
  description                     = "Central Transit Gateway for the organization"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name = "org-transit-gateway"
  }
}