# providers.tf - Configure AWS provider with default region
variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

provider "aws" {
  region = var.region
}
