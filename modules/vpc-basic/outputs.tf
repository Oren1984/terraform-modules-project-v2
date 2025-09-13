# outputs.tf - Core IDs

output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "igw_id" { value = aws_internet_gateway.igw.id }
output "route_table_id" { value = aws_route_table.public.id }
