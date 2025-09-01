variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "prod_account_id" {
  description = "The AWS Account ID for the Production workload account."
  type        = string
}