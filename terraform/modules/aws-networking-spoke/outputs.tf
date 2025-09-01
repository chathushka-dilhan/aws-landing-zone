output "vpc_id" {
  description = "The ID of the created spoke VPC."
  value       = aws_vpc.spoke.id
}

output "private_subnet_ids" {
  description = "A list of IDs for the private subnets."
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "A list of IDs for the public subnets."
  value       = aws_subnet.public[*].id
}