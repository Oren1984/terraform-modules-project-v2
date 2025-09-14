# main.tf - Final stack: VPC + EC2 web + S3 + RDS (minimal)

module "vpc" {
  source              = "./modules/vpc-basic"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"] # now two subnets (DB needs >=2)
  tags                = var.project_tags
}

module "ec2" {
  source                    = "./modules/ec2-web"
  subnet_id                 = module.vpc.public_subnet_ids[0] # first public subnet
  instance_type             = "t3.micro"
  create_sg                 = true
  key_name                  = null
  iam_instance_profile_name = null
  enable_cpu_alarm          = true
  cpu_threshold             = 70
  tags                      = var.project_tags
}

module "s3" {
  source                    = "./modules/s3-basic"
  bucket_name_prefix        = "oren-modules-demo"
  enable_versioning         = true
  lifecycle_days_to_glacier = 30
  tags                      = var.project_tags
}

# SG for RDS: allow 3306 only from the EC2 Security Group
resource "aws_security_group" "rds" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL from EC2 SG only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.ec2.sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS minimal (public subnets for now; publicly_accessible=true just for demo)
module "rds" {
  source                 = "./modules/rds-mysql-basic"
  name_prefix            = "demo"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "appuser"
  password               = "ChangeMe123!"               # move to tfvars/SSM later
  subnet_ids             = module.vpc.public_subnet_ids # needs >=2 subnets
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true # minimal demo; switch to false when moving to private
}

# This block wires the minimal ALB and attaches the EC2 instance to its target group.
module "alb" {
  source      = "./modules/alb-basic"
  name_prefix = "demo"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  target_port = 80
}

# Conect-EC2 to -TG (instance target)
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = module.alb.target_group_arn
  target_id        = module.ec2.instance_id
  port             = 80
}

# This block wires a minimal ECS Fargate service (nginx) into the existing VPC subnets.
module "ecs" {
  source           = "./modules/ecs-basic"
  name_prefix      = "demo"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.public_subnet_ids
  assign_public_ip = true
  container_image  = "nginx:latest"
  desired_count    = 1
  cpu              = 256
  memory           = 512
  cpu_threshold    = 70
  tags             = var.project_tags
}

# Outputs
output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_id" { value = module.vpc.public_subnet_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "ec2_instance_id" { value = module.ec2.instance_id }
output "ec2_public_ip" { value = module.ec2.public_ip }
output "ec2_cpu_alarm" { value = module.ec2.cpu_alarm_name }
output "s3_bucket_name" { value = module.s3.bucket_name }
output "rds_endpoint" { value = module.rds.db_endpoint }
output "rds_alarm_arn" { value = module.rds.alarm_cpu_high_arn }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "alb_alarm_arn" { value = module.alb.alarm_latency_arn }
output "ecs_cluster_name" { value = module.ecs.cluster_name }
output "ecs_service_name" { value = module.ecs.service_name }
output "ecs_alarm_name" { value = module.ecs.alarm_name }
