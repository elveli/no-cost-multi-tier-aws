# ECS Cluster
resource "aws_ecs_cluster" "no-cost-app_cluster" {
  name = "no-cost-app-cluster"

  tags = var.common_tags
}

# IAM Role for Fargate Task (placeholder)
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

# Attach AmazonECSTaskExecutionRolePolicy (placeholder)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Fargate Task Definition (no container runs yet)
resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ecs-container"
      image     = "amazonlinux:2"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = var.common_tags
}

# Optional Fargate Service Placeholder (desired_count = 0)
resource "aws_ecs_service" "app_service" {
  name            = "no-cost-app-ecs-service"
  cluster         = aws_ecs_cluster.no-cost-app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 0
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [for s in values(aws_subnet.no-cost-private-sub) : s.id]
    security_groups = [aws_security_group.no-cost-private-sg.id]
    assign_public_ip = false
  }

  tags = var.common_tags
}
