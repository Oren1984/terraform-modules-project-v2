# This file exposes the EC2 instance and its SG id.
output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}


output "cpu_alarm_name" {
  value = try(aws_cloudwatch_metric_alarm.cpu_high[0].alarm_name, null)
}


output "sg_id" {
  value = try(aws_security_group.web[0].id, null)
}
