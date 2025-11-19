variable "region" {
  default = "us-west-2"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"   # or your preferred region
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b"]
}

# ALB variables
variable "alb_name" {
  type        = string
  default     = "no-cost-alb"
  description = "Name of the Application Load Balancer"
}

variable "alb_enable_https" {
  type        = bool
  default     = false
  description = "Enable HTTPS listener for ALB"
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "ARN of the ACM certificate for HTTPS listener"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_asg_size" {
  description = "Min ASG size"
  type        = number
  default     = 0
}

variable "max_asg_size" {
  description = "Max ASG size"
  type        = number
  default     = 1
}

variable "desired_ecs_task_count" {
  description = "Desired ECS task count"
  type        = number
  default     = 0
}

variable "ecs-cw-retention-in-days" {
  description = "Cloudwatch ECS log retention in days"
  type = number 
  default = 1
}

variable "ec2_min_capacity" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "ec2_max_capacity" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 4
}

variable "ec2_desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

# Tags
variable "common_tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Terraform = "true"
    Project     = "no-cost-multi-tier"
  }
}

locals {
  private_to_public_map = {
    "no-cost-private-subnet-1" = "no-cost-public-subnet-1"
    "no-cost-private-subnet-2" = "no-cost-public-subnet-2"
  }
}
