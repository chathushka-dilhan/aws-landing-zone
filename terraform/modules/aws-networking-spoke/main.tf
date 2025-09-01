# Create a spoke VPC and attach it to the central Transit Gateway
# This module assumes that the AWS provider is configured to use the appropriate account.

resource "aws_vpc" "spoke" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.environment}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.spoke.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}

# Attach this VPC to the central Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_attachment" {
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.spoke.id

  tags = {
    Name = "${var.environment}-tgw-attachment"
  }
}