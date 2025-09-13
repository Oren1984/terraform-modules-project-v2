# variables.tf - Inputs for a minimal EC2 web server with optional CPU alarm

variable "subnet_id" {
  description = "Subnet ID where the instance will run (public)"
  type        = string
}

variable "security_group_ids" {
  description = "Extra security groups to attach (optional)"
  type        = list(string)
  default     = []
}

variable "create_sg" {
  description = "Create a basic SG that allows HTTP/HTTPS outbound-any"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Override AMI ID (null = latest Amazon Linux 2023)"
  type        = string
  default     = null
}

variable "key_name" {
  description = "EC2 key pair name (optional, for SSH)"
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "Optional IAM instance profile name"
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Attach public IP (true for public subnet)"
  type        = bool
  default     = true
}

variable "enable_cpu_alarm" {
  description = "Create CloudWatch alarm for CPU utilization"
  type        = bool
  default     = true
}

variable "cpu_threshold" {
  description = "CPU threshold percent"
  type        = number
  default     = 70
}

variable "period" {
  description = "Metric period in seconds"
  type        = number
  default     = 60
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate"
  type        = number
  default     = 2
}

variable "alarm_actions" {
  description = "Optional SNS topic ARNs to notify"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
