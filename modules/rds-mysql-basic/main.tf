# This file creates a minimal MySQL RDS instance and its DB subnet group.
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-mysql"
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot    = true
  publicly_accessible    = var.publicly_accessible
  deletion_protection    = false
}

# CloudWatch Alarm: RDS CPU > 70% (2 periods x 60s) -> minimal signal
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_prefix}-rds-cpu-gt-70"
  alarm_description   = "RDS CPUUtilization > 70% for 2 minutes"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 2
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
  treat_missing_data = "notBreaching"

}
