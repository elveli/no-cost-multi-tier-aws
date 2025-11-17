# Security Group is optional for NLB (not required for TCP/UDP)
# Only required if you attach a private NLB to internal resources

# Create Network Load Balancer
resource "aws_lb" "no-cost-nlb" {
  name               = "no-cost-nlb"
  load_balancer_type = "network"
  internal           = false
  subnets            = [for s in values(aws_subnet.no-cost-public-sub) : s.id]

  enable_deletion_protection = false

  tags = var.common_tags
}

# TCP Target Group (empty)
resource "aws_lb_target_group" "no-cost-nlb-tg" {
  name     = "no-cost-nlb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.no-cost-main.id

  # Health check (optional)
  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    protocol            = "TCP"
  }

  tags = var.common_tags
}

# Listener
resource "aws_lb_listener" "no-cost-nlb-listener" {
  load_balancer_arn = aws_lb.no-cost-nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.no-cost-nlb-tg.arn
  }
}
