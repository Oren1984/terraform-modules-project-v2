# This file exposes key outputs from the minimal RDS module.
output "db_endpoint" { value = aws_db_instance.this.address }
output "db_id" { value = aws_db_instance.this.id }
output "alarm_cpu_high_arn" { value = aws_cloudwatch_metric_alarm.cpu_high.arn }
