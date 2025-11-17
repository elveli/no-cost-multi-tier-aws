# Step scaling policy (scale out)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "backend-scale-out"
  autoscaling_group_name = aws_autoscaling_group.backend_asg.name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"

  step_adjustment {
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 10
    scaling_adjustment          = 1
  }
  step_adjustment {
    metric_interval_lower_bound = 10
    scaling_adjustment          = 2
  }
}

# Step scaling policy (scale in)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "backend-scale-in"
  autoscaling_group_name = aws_autoscaling_group.backend_asg.name
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }
}

# CloudWatch alarms to trigger scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "backend-high-cpu"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 120
  evaluation_periods  = 2
  threshold           = 70
  comparison_operator = "GreaterThanThreshold"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.backend_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "backend-low-cpu"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 120
  evaluation_periods  = 2
  threshold           = 30
  comparison_operator = "LessThanThreshold"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.backend_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}

