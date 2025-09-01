output "transit_gateway_id" {
  description = "The ID of the Transit Gateway."
  value       = aws_ec2_transit_gateway.hub.id
}

output "transit_gateway_arn" {
  description = "The ARN of the Transit Gateway."
  value       = aws_ec2_transit_gateway.hub.arn
}