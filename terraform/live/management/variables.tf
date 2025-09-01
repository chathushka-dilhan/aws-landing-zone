variable "aws_region" {
  description = "The primary AWS region for the organization."
  type        = string
  default     = "us-east-1"
}

variable "sso_instance_arn" {
  description = "The ARN of the IAM Identity Center instance (e.g., arn:aws:sso:::instance/ssoins-xxxxxxxxxxxxxxxx)."
  type        = string
}