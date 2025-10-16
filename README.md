# terraform-modules-project (V2)

Minimal, junior-friendly Terraform stack built from small composable modules:
- **vpc-basic** — VPC with 2 public subnets (across AZs), IGW, route table.
- **ec2-web** — EC2 (AL2023 via SSM), optional SG, CloudWatch alarm (CPU > 70%).
- **s3-basic** — S3 with Versioning + Lifecycle to Glacier.
- **rds-mysql-basic** — RDS MySQL (minimal) + CloudWatch alarm (CPU > 70%).
- **alb-basic** — ALB + target group + listener (HTTP/80) + latency alarm (> 0.7s).
- **ecs-basic** — ECS Fargate (nginx) with public IP + CloudWatch alarm (CPU > 70%).

All modules avoid hard-coding and expose clear inputs/outputs. 

---

## Quick start

**Prereqs**
- Terraform ≥ 1.5
- AWS credentials configured (`aws configure`) and region set (`AWS_REGION` or `providers.tf`)

**Run**
```bash
terraform fmt -recursive
terraform init -upgrade
terraform validate
terraform plan -out=tfplan.bin
terraform apply tfplan.bin


Key outputs (examples)

VPC: vpc_id, public_subnet_ids

EC2: ec2_instance_id, ec2_public_ip, ec2_cpu_alarm

S3: s3_bucket_name

RDS: rds_endpoint, rds_alarm_arn

ALB: alb_dns_name, alb_alarm_arn

ECS: ecs_cluster_name, ecs_service_name, ecs_alarm_name

Cleanup

If the S3 bucket isn’t force_destroy:

aws s3 rm "s3://<bucket>" --recursive || true


Then:

terraform destroy -auto-approve

---

Repo layout
.
├─ main.tf            # Composes modules into the final stack
├─ providers.tf       # AWS provider + region
├─ versions.tf        # Terraform & provider version constraints
├─ variables.tf       # Shared inputs (e.g., tags)
├─ outputs.tf         # Root-level outputs
├─ evidence-root.*    # Optional root evidence
└─ modules/
   ├─ vpc-basic/
   ├─ ec2-web/
   ├─ s3-basic/
   ├─ rds-mysql-basic/
   ├─ alb-basic/
   └─ ecs-basic/
     (each with: main.tf, variables.tf, outputs.tf, README.md)


State/plan files are ignored via .gitignore

---

## 🧪 Infrastructure Validation

All Terraform modules (**S3**, **VPC**, **EC2**, **ECS**, **RDS**, **ALB**) were validated locally using:

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan.bin
terraform destroy -auto-approve
Validation results:

All modules successfully initialized and validated.

terraform plan produced correct resource previews without errors.

No apply was executed (logical validation only) to avoid AWS resource charges.

Each module includes its own outputs.tf file showing verified configurations.

✅ Terraform configurations verified successfully across all modules.

---
