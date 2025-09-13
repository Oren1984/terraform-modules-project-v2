# variables.tf - Root-level shared variables (tags, etc.)
variable "project_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = { Project = "terraform-modules", Owner = "oren" }
}
