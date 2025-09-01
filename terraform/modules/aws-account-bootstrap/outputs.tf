output "cicd_role_arn" {
  description = "The ARN of the created CI/CD IAM role."
  value       = aws_iam_role.cicd_role.arn
}