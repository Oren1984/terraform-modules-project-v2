# This file declares inputs for the minimal ALB module.
variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_port" {
  type    = number
  default = 80
}
