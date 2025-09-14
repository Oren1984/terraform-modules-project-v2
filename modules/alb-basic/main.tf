# This file creates an Application Load Balancer, a Target Group, a Listener, and a 0.7s latency alarm.
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Allow HTTP from the internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name_prefix}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# CloudWatch Alarm: TargetResponseTime > 0.7s (Average, 2x60s)
resource "aws_cloudwatch_metric_alarm" "latency_07s" {
  alarm_name          = "${var.name_prefix}-alb-latency-gt-0.7s"
  alarm_description   = "ALB TargetResponseTime > 0.7s for 2 minutes"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "TargetResponseTime"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 2
  threshold           = 0.7
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    LoadBalancer = aws_lb.this.arn_suffix
  }
  treat_missing_data = "notBreaching"
}
