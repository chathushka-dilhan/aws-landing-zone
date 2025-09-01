output "administrator_access_ps_arn" {
  description = "ARN of the AdministratorAccess permission set."
  value       = aws_ssoadmin_permission_set.administrator_access.arn
}

output "view_only_access_ps_arn" {
  description = "ARN of the ViewOnlyAccess permission set."
  value       = aws_ssoadmin_permission_set.view_only_access.arn
}