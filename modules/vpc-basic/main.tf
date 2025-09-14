# This block fetches available AZ names so we can spread subnets across AZs.
data "aws_availability_zones" "available" {
  state = "available"
}

# Pick as many AZs as we have public subnets (first N AZs).
locals {
  public_azs = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name = "demo-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "demo-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "demo-public-rt" })
}

# two public subnets distributed across different AZs
# two public subnets distributed across different AZs, stable keys by CIDR
resource "aws_subnet" "public" {
  for_each = { for cidr in var.public_subnet_cidrs : cidr => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.key
  availability_zone       = local.public_azs[index(var.public_subnet_cidrs, each.key)]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "demo-public-${replace(each.key, "/\\./", "-")}" })
}

