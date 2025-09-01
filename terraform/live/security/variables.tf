variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "log_archive_account_id" {
  description = "The AWS Account ID for the Log Archive account."
  type        = string
}

variable "security_tooling_account_id" {
  description = "The AWS Account ID for the Security Tooling account."
  type        = string
}