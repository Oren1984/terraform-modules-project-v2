# ecs-basic

Minimal ECS Fargate service running **nginx**:
- ECS Cluster
- Task Definition (nginx:latest, port 80) + CloudWatch logs
- Fargate Service (public IP, awsvpc)
- Security Group (allow HTTP 80)
- CloudWatch Alarm: `CPUUtilization > 70%` (Average, 2x60s)

**Inputs**
- `name_prefix`, `vpc_id`, `subnet_ids`
- `assign_public_ip` (default: true)
- `container_image` (default: nginx:latest)
- `cpu` (256), `memory` (512), `desired_count` (1), `cpu_threshold` (70)
- `tags` (map)

**Outputs**
- `cluster_name`, `service_name`, `task_def_arn`, `service_sg_id`, `alarm_name`


