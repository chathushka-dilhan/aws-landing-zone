variable "environment" {
  description = "The name of the environment (e.g., dev, prod)."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of Availability Zones to deploy subnets into."
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "The ID of the central Transit Gateway to attach to."
  type        = string
}