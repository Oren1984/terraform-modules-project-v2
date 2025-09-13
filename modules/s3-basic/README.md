# S3 Basic Module

This module creates a simple S3 bucket with:
- Versioning (enabled by default)
- Lifecycle transition to Glacier Instant Retrieval after 30 days

## Inputs
- `bucket_name_prefix` – prefix for the bucket name (random suffix added automatically)
- `enable_versioning` – enable or disable versioning (default: true)
- `lifecycle_days_to_glacier` – days before objects move to Glacier IR (default: 30)
- `tags` – optional tags for the bucket

## Outputs
- `bucket_name` – name of the created bucket
- `bucket_arn` – ARN of the created bucket

## Example
```hcl
module "s3" {
  source                     = "./modules/s3-basic"
  bucket_name_prefix         = "oren-modules-demo"
  enable_versioning          = true
  lifecycle_days_to_glacier  = 30
  tags = {
    Project = "terraform-modules"
    Owner   = "oren"
  }
}
