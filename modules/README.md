# Terraform Modules (V2) — Overview

Minimal, composable Terraform modules for AWS stack.  
Each module exposes focused inputs/outputs and keeps config simple.

-

## Modules
- **vpc-basic** – VPC with 2 public subnets across AZs, IGW, route table.
  - Outputs: `vpc_id`, `public_subnet_id`, `public_subnet_ids`
  

- **ec2-web** – EC2 (e.g., t3.micro) + optional SG + CPU>70% alarm.
  - Outputs: `instance_id`, `public_ip`, `cpu_alarm_name`, `sg_id`
  

- **s3-basic** – S3 bucket with Versioning + Lifecycle to Glacier.
  - Outputs: `bucket_name`
 

- **rds-mysql-basic** – Minimal RDS MySQL + CPU>70% alarm.
  - Outputs: `db_identifier`, `endpoint`, `alarm_arn`
  

- **alb-basic** – ALB + Target Group + Listener (HTTP/80) + latency alarm (>0.7s).
  - Outputs: `alb_dns_name`, `alb_arn`, `target_group_arn`, `alarm_arn`
 

- **ecs-basic** – ECS Fargate service (nginx) with public IP + CPU>70% alarm.
  - Outputs: `cluster_name`, `service_name`, `task_def_arn`, `service_sg_id`, `alarm_name`
  -

-

## Composition
- `vpc-basic` feeds `vpc_id` and `public_subnet_ids` to EC2/ALB/RDS/ECS.
- `s3-basic` is independent.
- ECS is deployed with a public IP (no ALB in this demo), but can be attached later (target type `ip`).

-

## Usage (root)
```bash
terraform fmt -recursive
terraform init -upgrade
terraform validate
terraform plan -out=tfplan.bin
terraform apply tfplan.bin

---


