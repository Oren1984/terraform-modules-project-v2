# main.tf - Stage 1: run S3 module only for isolated testing
module "s3" {
  source                    = "./modules/s3-basic"
  bucket_name_prefix        = "oren-modules-demo"
  enable_versioning         = true
  lifecycle_days_to_glacier = 30
  tags                      = var.project_tags
}

# Outputs for quick visibility after apply
output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = module.s3.bucket_arn
}


# main.tf - Stage 2: run VPC module only for isolated testing

module "vpc" {
  source             = "./modules/vpc-basic"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  tags               = var.project_tags
}

output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_id" { value = module.vpc.public_subnet_id }
output "igw_id" { value = module.vpc.igw_id }
output "route_table_id" { value = module.vpc.route_table_id }
