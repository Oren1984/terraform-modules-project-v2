# alb-basic

Minimal Application Load Balancer module:
- ALB (HTTP:80) + Security Group
- Target Group (HTTP:80)
- Listener (HTTP:80 → TG)
- CloudWatch Alarm: TargetResponseTime > 0.7s (Average, 2x60s)

**Inputs**
- `name_prefix` (string)
- `vpc_id` (string)
- `subnet_ids` (list(string)) – public
- `target_port` (number, default: 80)

**Outputs**
- `alb_dns_name`
- `target_group_arn`
- `alb_sg_id`
- `alarm_latency_arn`

**Evidence (after deploy)**
- `terraform output` / `-json`
- `aws elbv2 describe-load-balancers`
- `aws elbv2 describe-target-groups`
- `aws cloudwatch describe-alarms`
