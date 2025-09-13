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
