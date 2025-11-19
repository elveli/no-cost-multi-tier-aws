# =====================================
# Launch Template for EC2 Auto-Scaling
# =====================================

resource "aws_launch_template" "ec2_lt" {
  name_prefix   = "no-cost-ec2-lt-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.no-cost-ec2-sg.id]

  # Use gzip compression for large user data
  user_data = base64gzip(templatefile("${path.module}/user_data.sh", {}))

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "no-cost-ec2-asg-instance"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# =====================================
# Auto Scaling Group for EC2
# =====================================

resource "aws_autoscaling_group" "ec2_asg" {
  name                = "no-cost-ec2-asg"
  vpc_zone_identifier = [for s in values(aws_subnet.no-cost-public-sub) : s.id]
  
  min_size         = var.ec2_min_capacity
  max_size         = var.ec2_max_capacity
  desired_capacity = var.ec2_desired_capacity
  
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }

  # Attach to EC2 target group
  target_group_arns = [aws_lb_target_group.ec2_http_tg.arn]

  # Enable metrics collection
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "no-cost-ec2-asg-instance"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# =====================================
# EC2 CPU-Based Step Scaling Policy
# =====================================

# Scale UP policy - increase instances when CPU > 70%
resource "aws_autoscaling_policy" "ec2_scale_up" {
  name                   = "ec2-cpu-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

# Scale DOWN policy - decrease instances when CPU < 30%
resource "aws_autoscaling_policy" "ec2_scale_down" {
  name                   = "ec2-cpu-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.ec2_asg.name
}

# =====================================
# CloudWatch Alarms for EC2 Scaling
# =====================================

# Alarm for scaling UP (CPU > 70%)
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "ec2-asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60  # 1 minute
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Scale-up EC2 ASG when CPU > 70%"
  alarm_actions       = [aws_autoscaling_policy.ec2_scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }

  tags = merge(var.common_tags, {
    Name = "ec2-cpu-high-alarm"
  })
}

# Alarm for scaling DOWN (CPU < 30%)
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_low" {
  alarm_name          = "ec2-asg-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60  # 1 minute
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "Scale-down EC2 ASG when CPU < 30%"
  alarm_actions       = [aws_autoscaling_policy.ec2_scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }

  tags = merge(var.common_tags, {
    Name = "ec2-cpu-low-alarm"
  })
}

# =====================================
# Optional: Network-Based Scaling
# =====================================

# Scale UP when network bytes in > 1 million (high traffic)
resource "aws_cloudwatch_metric_alarm" "ec2_network_high" {
  alarm_name          = "ec2-asg-network-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1000000  # 1 million bytes
  alarm_description   = "Scale-up EC2 ASG when network traffic is high"
  alarm_actions       = [aws_autoscaling_policy.ec2_scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2_asg.name
  }

  tags = merge(var.common_tags, {
    Name = "ec2-network-high-alarm"
  })
}

# =====================================
# Optional: ALB Target Group Health
# =====================================

# Scale UP when healthy host count is low
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "Alert when unhealthy hosts in target group"

  dimensions = {
    LoadBalancer = aws_lb.no-cost-alb.arn_suffix
    TargetGroup  = aws_lb_target_group.ec2_http_tg.arn_suffix
  }

  tags = merge(var.common_tags, {
    Name = "alb-unhealthy-hosts-alarm"
  })
}

data "aws_instances" "ec2_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ec2_asg.name]
  }

  depends_on = [aws_autoscaling_group.ec2_asg]
}

# =====================================
# Outputs
# =====================================

output "ec2_asg_name" {
  description = "Name of EC2 Auto Scaling Group"
  value       = aws_autoscaling_group.ec2_asg.name
}

output "ec2_asg_min_size" {
  description = "Minimum number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.min_size
}

output "ec2_asg_max_size" {
  description = "Maximum number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.max_size
}

output "ec2_asg_desired_capacity" {
  description = "Desired number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.desired_capacity
}

output "ec2_launch_template_id" {
  description = "Launch template ID for EC2 ASG"
  value       = aws_launch_template.ec2_lt.id
}