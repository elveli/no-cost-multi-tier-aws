# -------------------------------------
# 1. SECURITY GROUPS
# -------------------------------------

# ALB Security Group (Shared by both services)
resource "aws_security_group" "no-cost-alb-sg" {
  name        = "no-cost-alb-sg"
  description = "Allow HTTP/HTTPS from anywhere"
  vpc_id      = aws_vpc.no-cost-main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "no-cost-alb-sg"
  }
}

# EC2 Security Group (allow traffic from ALB)
resource "aws_security_group" "no-cost-ec2-sg" {
  name        = "no-cost-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.no-cost-main.id
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # Allow traffic ONLY from the single ALB's SG
    security_groups = [aws_security_group.no-cost-alb-sg.id] 
  }
  
  # Optional: SSH access (remove if not needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "no-cost-ec2-sg"
  }
}

# -------------------------------------
# 2. EC2 INSTANCE
# -------------------------------------

# Get the latest AMI
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "no-cost-app" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = values(aws_subnet.no-cost-public-sub)[0].id
  vpc_security_group_ids      = [aws_security_group.no-cost-ec2-sg.id] 
  associate_public_ip_address = true
  user_data_base64            = base64gzip(templatefile("${path.module}/user_data.sh", {})) 
  user_data_replace_on_change = true
  
  tags = {
    Name = "no-cost-ec2"
  }
}

# -------------------------------------
# 3. ALB, TARGET GROUP, AND LISTENER RULES
# -------------------------------------

# Application Load Balancer (THE SINGLE ALB)
resource "aws_lb" "no-cost-alb" {
  name               = "no-cost-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.no-cost-alb-sg.id]
  subnets            = values(aws_subnet.no-cost-public-sub)[*].id
  
  enable_deletion_protection = false
  
  tags = {
    Name = "no-cost-alb"
  }
}

# EC2 Target Group (for /legacy/* traffic)
resource "aws_lb_target_group" "ec2_http_tg" {
  name     = "ec2-http-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.no-cost-main.id
  
  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
  
  tags = {
    Name = "ec2-http-tg"
  }
}

# Register EC2 instance with its target group
resource "aws_lb_target_group_attachment" "no-cost-tg-attachment" {
  target_group_arn = aws_lb_target_group.ec2_http_tg.arn
  target_id        = aws_instance.no-cost-app.id
  port             = 80
}

# HTTP Listener (default action points to ECS TG defined in ecs.tf)
resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-alb.arn
  port              = 80
  protocol          = "HTTP"
  
  # Default Action: FORWARD to the ECS Target Group (defined in ecs.tf)
  # This makes the ECS service the primary/default application.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }
}

# Listener Rule 1: Route /legacy/* to the EC2 Target Group
resource "aws_lb_listener_rule" "ec2_legacy_rule" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 10 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_http_tg.arn
  }

  condition {
    path_pattern {
      values = ["/legacy/*"]
    }
  }
}

# Listener Rule 2: Route /api/* to the ECS Target Group
resource "aws_lb_listener_rule" "ecs_api_rule" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 5 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}