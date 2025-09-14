# This file declares minimal VPC inputs including two public subnets.
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
