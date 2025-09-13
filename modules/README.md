# Terraform Modules (Overview)

This folder contains three minimal, junior-friendly modules designed to be combined into a simple stack (VPC + EC2 + S3). Each module avoids hard-coding by exposing inputs and returning outputs for composition.

## s3-basic
- Creates an S3 bucket with Versioning + Lifecycle to Glacier IR (days configurable).
- Randomized bucket name suffix (no hard-coded names).
- Evidence: `modules/s3-basic/evidence/` (e.g., outputs.json, bucket_name.txt).

## vpc-basic
- Minimal VPC with one **public** subnet, Internet Gateway, route table + default route.
- Public IPs on launch for instances in the subnet.
- Evidence: `modules/vpc-basic/evidence/` (e.g., outputs.json, vpc_id.txt).

## ec2-web
- Small EC2 instance (default `t3.micro`) with Nginx “Hello” page (user_data).
- AMI via SSM Parameter (AL2023) by default; optional CPU >70% CloudWatch alarm.
- Optional built-in SG (HTTP/HTTPS in, all egress) or attach your own SGs.
- Evidence: `modules/ec2-web/evidence/` (outputs.json, instance_id.txt, public_ip.txt).

## How they fit together
- `vpc-basic` → provides `public_subnet_id`.
- `ec2-web` → uses that subnet; exposes `public_ip`.
- `s3-basic` → independent storage bucket for artifacts/logs/etc.
