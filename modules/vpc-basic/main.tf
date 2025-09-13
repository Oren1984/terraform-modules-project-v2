# main.tf - Creates a minimal VPC with one public subnet and Internet access

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "vpc-basic" })
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  # No AZ attribute → AWS automatically select availability
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "public-subnet" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "public-rt" })
}

resource "aws_route" "default_inet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
