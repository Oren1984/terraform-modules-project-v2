# This file exposes VPC and public subnet outputs.
output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

# kept for backward-compat: first subnet id
output "public_subnet_id" {
  value = length([for s in aws_subnet.public : s.id]) > 0 ? [for s in aws_subnet.public : s.id][0] : null
}
