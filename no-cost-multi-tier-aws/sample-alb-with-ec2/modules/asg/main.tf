data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "demo-ec2-sg"
  description = "Allow ALB access"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "demo-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y nginx1
              echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
              systemctl enable nginx
              systemctl start nginx
            EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.alb_target_group_arn]
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "cpu-scale-up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = 1
  cooldown                = 60
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "cpu-scale-down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type         = "ChangeInCapacity"
  scaling_adjustment      = -1
  cooldown                = 120
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scale_up_threshold
  alarm_description   = "Scale up when CPU > threshold"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.scale_down_threshold
  alarm_description   = "Scale down when CPU < threshold"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}

