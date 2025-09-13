# main.tf - Launches a small EC2 web server + optional CPU alarm (>70%)

# --- Data sources ---
# Latest Amazon Linux 2023 (x86_64) via SSM Parameter (no hard-code)
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Subnet info (to get VPC ID for SG)
data "aws_subnet" "sel" {
  id = var.subnet_id
}

# --- Locals ---
locals {
  # Prefer provided AMI; otherwise take SSM value
  final_ami = var.ami_id != null ? var.ami_id : data.aws_ssm_parameter.al2023.value

  # Simple user_data to expose a page on :80
  user_data = <<-EOT
    #!/bin/bash
    dnf -y install nginx
    systemctl enable nginx
    echo "Hello from ec2-web via Terraform" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOT
}

# --- Resources ---
# (Optional) Security Group that allows HTTP/HTTPS + all egress
resource "aws_security_group" "web" {
  count       = var.create_sg ? 1 : 0
  name        = "ec2-web-sg"
  description = "Allow HTTP/HTTPS"
  vpc_id      = data.aws_subnet.sel.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "ec2-web-sg" })
}

resource "aws_instance" "this" {
  ami           = local.final_ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  # Compute SG IDs inline to avoid locals depending on resources
  vpc_security_group_ids = var.create_sg ? concat(var.security_group_ids, [aws_security_group.web[0].id]) : var.security_group_ids

  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile_name
  user_data                   = local.user_data

  tags = merge(var.tags, { Name = "ec2-web" })
}

# CloudWatch alarm on CPU (> threshold)
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count               = var.enable_cpu_alarm ? 1 : 0
  alarm_name          = "ec2-${aws_instance.this.id}-cpu-high"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = var.period
  evaluation_periods  = var.evaluation_periods
  threshold           = var.cpu_threshold
  comparison_operator = "GreaterThanThreshold"
  alarm_description   = "CPU > ${var.cpu_threshold}%"
  alarm_actions       = var.alarm_actions

  dimensions = { InstanceId = aws_instance.this.id }
}
