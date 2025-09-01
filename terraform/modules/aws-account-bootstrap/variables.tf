variable "management_account_id" {
  description = "The AWS Account ID of the management account."
  type        = string
}

variable "budget_limit_usd" {
  description = "The monthly budget limit in USD for this account."
  type        = number
  default     = 100
}

variable "billing_alert_email" {
  description = "The email address to send billing alerts to."
  type        = string
}