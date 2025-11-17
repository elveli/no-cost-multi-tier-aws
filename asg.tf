data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "no-cost-asg-lt" {
  name_prefix   = "asg-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
}


# Auto Scaling Group (0 instances)
resource "aws_autoscaling_group" "asg" {
  name                 = "no-cost-asg-placeholder"
  max_size             = 1
  min_size             = 0
  desired_capacity      = 1
  vpc_zone_identifier  = values(aws_subnet.no-cost-private-sub)[*].id


  launch_template {
    id      = aws_launch_template.no-cost-asg-lt.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  force_delete               = true
  wait_for_capacity_timeout  = "0"

  tag {
    key                 = "Name"
    value               = "no-cost-asg"
    propagate_at_launch = true
  }
}

