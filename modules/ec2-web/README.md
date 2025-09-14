# EC2 Web Module

Launches a minimal EC2 instance with Nginx + optional CPU alarm. 
No hard-coding: AMI via SSM Parameter (Amazon Linux 2023), subnet and tags are inputs.

## What it creates
- EC2 instance (default: `t3.micro`)
- Optional Security Group (HTTP/HTTPS in, all egress)
- CloudWatch alarm on CPU > 70% (enabled by default)
- Simple `user_data` to serve a “Hello” page on port 80

## Inputs (short)
- `subnet_id` (string) — required, public subnet ID
- `instance_type` (string) — default `t3.micro`
- `ami_id` (string|null) — override AMI (default: latest AL2023 via SSM)
- `create_sg` (bool) — default `true` (creates basic SG)
- `security_group_ids` (list) — extra SGs to attach
- `associate_public_ip` (bool) — default `true`
- `key_name` (string|null) — optional SSH key pair
- `iam_instance_profile_name` (string|null) — optional instance profile
- `enable_cpu_alarm` (bool) — default `true`
- `cpu_threshold` (number) — default `70`
- `period`, `evaluation_periods`, `alarm_actions` — alarm tuning
- `tags` (map) — common tags

## Outputs
- `instance_id`
- `public_ip`
- `security_group_id` (if created)
- `cpu_alarm_name` (if created)

