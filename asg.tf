data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

/* resource "aws_launch_template" "no-cost-asg-lt" {
  name_prefix   = "asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
   # Use gzip compression for large user data
  #user_data = base64gzip(templatefile("${path.module}/user_data.sh", {}))
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {}))

} */

resource "aws_launch_template" "no-cost-asg-lt" {
  name_prefix   = "asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # Add this section:
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.no-cost-public-sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd

    # Create directories for each path
    mkdir -p /var/www/html/ec2
    mkdir -p /var/www/html/legacy
    
    # Add content
    echo "<h1>EC2 Instance - /ec2 path</h1>" > /var/www/html/ec2/index.html
    echo "<h1>EC2 Instance - /legacy path</h1>" > /var/www/html/legacy/index.html
    echo "<h1>EC2 Instance - root</h1>" > /var/www/html/index.html

    systemctl enable --now httpd
    #echo "<h1>Hello from EC2 $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
  )
}


# Auto Scaling Group (0 instances)
resource "aws_autoscaling_group" "asg" {
  name                 = "no-cost-asg"
  max_size             = var.max_asg_size
  min_size             = var.min_asg_size
  desired_capacity     = var.desired_asg_size
  #vpc_zone_identifier  = values(aws_subnet.no-cost-private-sub)[*].id xxx
  vpc_zone_identifier = [for s in values(aws_subnet.no-cost-public-sub) : s.id]



  launch_template {
    id      = aws_launch_template.no-cost-asg-lt.id
    version = "$Latest"
    
  }

  target_group_arns = [aws_lb_target_group.ec2_http_tg.arn]

  health_check_type          = "EC2"
  force_delete               = true
  wait_for_capacity_timeout  = "0"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "no-cost-asg"
    propagate_at_launch = true
  }
}

