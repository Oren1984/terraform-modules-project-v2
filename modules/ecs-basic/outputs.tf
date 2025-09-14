# This file exposes ECS cluster/service identifiers and the service SG id.
output "cluster_name" { value = aws_ecs_cluster.this.name }
output "service_name" { value = aws_ecs_service.this.name }
output "task_def_arn" { value = aws_ecs_task_definition.this.arn }
output "service_sg_id" { value = aws_security_group.svc.id }
output "alarm_name" { value = aws_cloudwatch_metric_alarm.cpu_high.alarm_name }
