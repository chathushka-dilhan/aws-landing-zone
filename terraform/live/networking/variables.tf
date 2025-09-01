variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "network_account_id" {
  description = "The AWS Account ID for the Network account."
  type        = string
}