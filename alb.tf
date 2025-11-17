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

# EC2 Security Group (allow traffic from ALB)
resource "aws_security_group" "no-cost-ec2-sg" {
  name        = "no-cost-ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.no-cost-main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.no-cost-alb-sg.id]
  }

  # Optional: SSH access (remove if not needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP for security
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

# EC2 Instance with detailed monitoring page
resource "aws_instance" "no-cost-app" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  
  # Place in one of your public subnets
  subnet_id                   = values(aws_subnet.no-cost-public-sub)[0].id
  vpc_security_group_ids      = [aws_security_group.no-cost-alb-sg.id]
  associate_public_ip_address = true
  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {}))
  
  user_data_replace_on_change = true

  tags = {
    Name = "no-cost-app-instance"
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


# Register EC2 instance with target group
resource "aws_lb_target_group_attachment" "no-cost-tg-attachment" {
  target_group_arn = aws_lb_target_group.no-cost-http-tg.arn
  target_id        = aws_instance.no-cost-app.id
  port             = 80
}

# HTTP Listener
resource "aws_lb_listener" "no-cost-http-listener" {
  load_balancer_arn = aws_lb.no-cost-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.no-cost-http-tg.arn
  }
}

# Output the ALB DNS name to access the application
output "alb_dns_name" {
  value       = aws_lb.no-cost-app-alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "instance_public_ip" {
  value       = aws_instance.no-cost-app.public_ip
  description = "Public IP of the EC2 instance"
}