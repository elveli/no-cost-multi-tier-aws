# ALB Security Group
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

# Application Load Balancer
resource "aws_lb" "no-cost-app-alb" {
  name               = "no-cost-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.no-cost-alb-sg.id]
  subnets            = values(aws_subnet.no-cost-public-sub)[*].id

  enable_deletion_protection = false

  tags = {
    Name = "no-cost-app-alb"
  }
}

# HTTP Target Group (empty)
resource "aws_lb_target_group" "no-cost-http-tg" {
  name     = "no-cost-http-tg"
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
    Name = "no-cost-http-tg"
  }
}

/* # HTTPS Target Group (optional, empty)
resource "aws_lb_target_group" "no-cost-https-tg" {
  name     = "no-cost-https-tg"
  port     = 443
  protocol = "HTTPS"
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
    Name = "no-cost-https-tg"
  }
} */

/* # Listener for HTTP
resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.no-cost-http-tg.arn
  }
} */

# Listener for HTTPS (optional)
/** esource "aws_lb_listener" "no-cost-https-listener" {
  load_balancer_arn = aws_lb.no-cost-app-alb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = var.certificate_arn # Placeholder variable if you add SSL cert later

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.no-cost-https-tg.arn
  }
} */

/* resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "ALB placeholder"
      status_code  = 200
    }
  }
} */

/* resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No-cost placeholder listener"
      status_code  = "200"
    }
  }
} */

/* resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, no-cost listener!"
      status_code  = "200"
    }
  }
} */
