output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = [for i in range(length(local.subnet_with_type_index)) : aws_subnet.subnet[tostring(i)].id]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for i, type in var.subnet_types : aws_subnet.subnet[i].id if type == "public"]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for i, type in var.subnet_types : aws_subnet.subnet[i].id if type == "private"]
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.security_group.id
}

output "nat_gateway_id" {
  description = "NAT gateway ID"
  value       = var.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null
}
