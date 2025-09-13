# main.tf - Final stack: VPC + EC2 web + S3 (minimal)

module "vpc" {
  source             = "./modules/vpc-basic"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  tags               = var.project_tags
}

module "ec2" {
  source                    = "./modules/ec2-web"
  subnet_id                 = module.vpc.public_subnet_id
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

# Outputs
output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_id" { value = module.vpc.public_subnet_id }
output "ec2_instance_id" { value = module.ec2.instance_id }
output "ec2_public_ip" { value = module.ec2.public_ip }
output "ec2_cpu_alarm" { value = module.ec2.cpu_alarm_name }
output "s3_bucket_name" { value = module.s3.bucket_name }
