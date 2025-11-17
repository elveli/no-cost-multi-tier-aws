data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.backend_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.backend_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # small startup script that retrieves DB credentials from Secrets Manager and writes to /etc/app-config
    yum update -y
    yum install -y jq aws-cli httpd
    # Example: retrieve secret (requires IAM role)
    SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id ${aws_secretsmanager_secret.db_secret.name} --region ${var.aws_region} --query SecretString --output text)
    echo "$SECRET_JSON" > /etc/db-credentials.json
    cat <<HTML > /var/www/html/index.html
    Hello from backend \$(hostname)
    HTML
    systemctl enable httpd
    systemctl start httpd
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "backend-instance"
    }
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  name                      = "backend-asg"
  desired_capacity          = var.backend_desired
  min_size                  = var.backend_min
  max_size                  = var.backend_max
  vpc_zone_identifier       = aws_subnet.private-sub[*].id
  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.backend_tg.arn]
  health_check_type = "ELB"
  force_delete      = true

  tag {
    key                 = "Name"
    value               = "backend-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

