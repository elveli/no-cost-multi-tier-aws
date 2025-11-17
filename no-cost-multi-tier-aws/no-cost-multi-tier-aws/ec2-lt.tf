# EC2 Launch Template
resource "aws_launch_template" "no-cost-app_lt" {
  name_prefix   = "no-cost-app-lt-"
  image_id      = "ami-0c55b159cbfafe1f0"  # placeholder AMI, replace with valid AMI
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.no-cost-public-sg.id]
  }

  # Optional tags
  tag_specifications {
    resource_type = "instance"
    tags          = var.common_tags
  }
}
