# variables.tf - Input variables for the S3 basic module (prefix, versioning, lifecycle, tags)

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "lifecycle_days_to_glacier" {
  description = "Days before transitioning current objects to Glacier Instant Retrieval"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}
