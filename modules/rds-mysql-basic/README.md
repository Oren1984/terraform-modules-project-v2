# rds-mysql-basic

**What is this?**  
Minimal RDS MySQL module: creates a DB subnet group, a small MySQL instance, and a CloudWatch alarm (CPU > 70%).

**Inputs**
- `name_prefix` (string): logical name prefix.
- `engine_version` (string, default: `8.0`)
- `instance_class` (string, default: `db.t3.micro`)
- `allocated_storage` (number, default: `20`)
- `username` (string)
- `password` (string, sensitive)
- `subnet_ids` (list(string)) – preferably private subnets
- `vpc_security_group_ids` (list(string))
- `publicly_accessible` (bool, default: `false`)

**Outputs**
- `db_endpoint` – DNS endpoint of the DB
- `db_id` – Identifier
- `alarm_cpu_high_arn` – ARN of the CPU>70% alarm

**Evidence (after deploy)**
- Run `terraform output -json > modules/rds-mysql-basic/evidence.json`
- Optionally add `aws rds describe-db-instances --db-instance-identifier <ID> > modules/rds-mysql-basic/evidence-rds.json`
