output "organization_root_id" {
  description = "The ID of the organization's root."
  value       = aws_organizations_organization.main.root[0].id
}

output "security_ou_id" {
  description = "The ID of the Security OU."
  value       = aws_organizations_organizational_unit.security.id
}

output "infrastructure_ou_id" {
  description = "The ID of the Infrastructure OU."
  value       = aws_organizations_organizational_unit.infrastructure.id
}

output "workloads_ou_id" {
  description = "The ID of the Workloads OU."
  value       = aws_organizations_organizational_unit.workloads.id
}

output "sandbox_ou_id" {
  description = "The ID of the Sandbox OU."
  value       = aws_organizations_organizational_unit.sandbox.id
}