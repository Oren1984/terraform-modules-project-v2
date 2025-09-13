# outputs.tf - EC2 identifiers and alarm info

output "instance_id" { value = aws_instance.this.id }
output "public_ip" { value = try(aws_instance.this.public_ip, null) }
output "security_group_id" { value = try(aws_security_group.web[0].id, null) }
output "cpu_alarm_name" { value = try(aws_cloudwatch_metric_alarm.cpu_high[0].alarm_name, null) }
