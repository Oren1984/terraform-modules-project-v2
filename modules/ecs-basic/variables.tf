# This file declares inputs for a minimal ECS Fargate service running NGINX.
variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "assign_public_ip" {
  type    = bool
  default = true
}
variable "container_image" {
  type    = string
  default = "nginx:latest"
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "cpu" {
  type    = number
  default = 256
}
variable "memory" {
  type    = number
  default = 512
}
variable "cpu_threshold" {
  type    = number
  default = 70
}
variable "tags" {
  type    = map(string)
  default = {}
}
