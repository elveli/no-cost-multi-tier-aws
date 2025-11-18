# ECS Cluster
resource "aws_ecs_cluster" "no-cost-app_cluster" {
  name = "no-cost-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled" # Enable if needed, but adds cost
  }

  tags = var.common_tags
}

# CloudWatch Log Group for ECS Container Logs
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/no-cost-app"
  retention_in_days = 7 # Adjust as needed

  tags = var.common_tags
}

# =====================================
# IAM Roles
# =====================================

# Task Execution Role (for ECS to pull images, write logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Role (for your application to access AWS services)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

# Policy for ECS Exec (optional - for SSH-like access)
resource "aws_iam_role_policy" "ecs_exec_policy" {
  name = "ecs-exec-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

# =====================================
# Security Groups
# =====================================

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "no-cost-ecs-alb-sg"
  description = "Security group for ECS ALB"
  vpc_id      = aws_vpc.no-cost-main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "no-cost-alb-sg"
  })
}

# ECS Tasks Security Group (update your existing one or create new)
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "no-cost-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.no-cost-main.id

  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "no-cost-ecs-tasks-sg"
  })
}

# =====================================
# Application Load Balancer
# =====================================

resource "aws_lb" "app_alb" {
  name               = "no-cost-ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in values(aws_subnet.no-cost-public-sub) : s.id] # Use public subnets

  enable_deletion_protection = false

  tags = var.common_tags
}

resource "aws_lb_target_group" "app_tg" {
  name        = "no-cost-ecs-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.no-cost-main.id
  target_type = "ip" # Required for Fargate

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = var.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = var.common_tags
}

# =====================================
# ECS Task Definition
# =====================================

resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-container"
      image     = "nginx:latest" # Changed from amazonlinux:2
      essential = true
      
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      # Optional: Add environment variables
      # environment = [
      #   {
      #     name  = "ENVIRONMENT"
      #     value = "production"
      #   }
      # ]
    }
  ])

  tags = var.common_tags
}

# =====================================
# ECS Service
# =====================================

resource "aws_ecs_service" "app_service" {
  name            = "no-cost-ecs-service"
  cluster         = aws_ecs_cluster.no-cost-app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_ecs_task_count
  launch_type     = "FARGATE"

  # Enable ECS Exec for debugging
  enable_execute_command = true

  network_configuration {
    subnets          = [for s in values(aws_subnet.no-cost-private-sub) : s.id]
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "ecs-container"
    container_port   = 80
  }

  # Ensure ALB is created before service
  depends_on = [aws_lb_listener.http]

  lifecycle {
    ignore_changes = [desired_count]
  }
}

