# main.tf - Creates an S3 bucket with versioning and lifecycle to Glacier IR

resource "random_pet" "suffix" {}

locals {
  bucket_name = "${var.bucket_name_prefix}-${random_pet.suffix.id}"
}

resource "aws_s3_bucket" "this" {
  bucket = local.bucket_name
  tags   = merge(var.tags, { Name = local.bucket_name })
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "to-glacier"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.lifecycle_days_to_glacier
      storage_class = "GLACIER_IR"
    }
  }
}
