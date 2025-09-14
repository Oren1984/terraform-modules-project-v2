# This file exposes ALB outputs for quick verification.
output "alb_dns_name" { value = aws_lb.this.dns_name }
output "target_group_arn" { value = aws_lb_target_group.this.arn }
output "alb_sg_id" { value = aws_security_group.alb.id }
output "alarm_latency_arn" { value = aws_cloudwatch_metric_alarm.latency_07s.arn }
