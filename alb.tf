# =====================================
# SECURITY GROUPS
# =====================================

# ALB Security Group
resource "aws_security_group" "no-cost-alb-sg" {
  name        = "no-cost-alb-sg"
  description = "Allow HTTP/HTTPS from anywhere"
  vpc_id      = aws_vpc.no-cost-main.id
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTPS"
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

# EC2 Security Group
resource "aws_security_group" "no-cost-ec2-sg" {
  name        = "no-cost-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.no-cost-main.id
  
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.no-cost-alb-sg.id]
  }
  
  ingress {
    description = "SSH"
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

# =====================================
# APPLICATION LOAD BALANCER
# =====================================

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

# =====================================
# TARGET GROUPS
# =====================================

# EC2 Target Group
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
  
  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 86400
  }
  
  tags = {
    Name = "ec2-http-tg"
  }
}

# ECS Target Group
resource "aws_lb_target_group" "ecs_app_tg" {
  name        = "ecs-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.no-cost-main.id
  target_type = "ip"
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }
  
  tags = {
    Name = "ecs-app-tg"
  }
}

# =====================================
# HTTP LISTENER
# =====================================

resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }
}

# =====================================
# LISTENER RULES - PATH-BASED ROUTING
# =====================================

# Rule 1: Route /ec2/* to EC2 Target Group
resource "aws_lb_listener_rule" "route_ec2" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_http_tg.arn
  }

  condition {
    path_pattern {
      values = ["/ec2", "/ec2/*"]
    }
  }
}

# Rule 2: Route /ecs/* to ECS Target Group
resource "aws_lb_listener_rule" "route_ecs" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 15

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/ecs", "/ecs/*"]
    }
  }
}

# Rule 3: Route /api/* to ECS Target Group
resource "aws_lb_listener_rule" "route_api" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api", "/api/*"]
    }
  }
}

# Rule 4: Route /legacy/* to EC2 Target Group
resource "aws_lb_listener_rule" "route_legacy" {
  listener_arn = aws_lb_listener.no-cost-http-listener.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_http_tg.arn
  }

  condition {
    path_pattern {
      values = ["/legacy", "/legacy/*"]
    }
  }
}