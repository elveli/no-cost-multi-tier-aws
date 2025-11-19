output "vpc_id" {
  value = aws_vpc.no-cost-main.id
}

output "public_sg_id" {
  value = aws_security_group.no-cost-public-sg.id
}

output "private_sg_id" {
  value = aws_security_group.no-cost-private-sg.id
}

output "public_subnet_ids" {
  value = [for s in values(aws_subnet.no-cost-public-sub) : s.id]
}

output "private_subnet_ids" {
  value = [for s in values(aws_subnet.no-cost-private-sub) : s.id]
}

output "nat_gateway_ids" {
  value = [for n in values(aws_nat_gateway.no-cost-nat-gw) : n.id]
}

# Output
output "lambda_function_name" {
  value = aws_lambda_function.no-cost-dummy_lambda.function_name
}

output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.no-cost-dummy_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}


# Output the ALB DNS name to access the application
output "alb_dns_name" {
  value       = "https://${aws_lb.no-cost-alb.dns_name}"
  description = "DNS name of the Application Load Balancer"
}

/* output "instance_public_ip" {
  value       = aws_instance.no-cost-app.public_ip
  description = "Public IP of the EC2 instance"
} */

/* # With this:
output "ec2_asg_instances" {
  description = "EC2 instances in Auto Scaling Group"
  value       = aws_autoscaling_group.ec2_asg.name
} */

/* output "ec2_asg_current_size" {
  description = "Current number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.desired_capacity
} */
/* 
# To get instance IPs, use:
output "ec2_instance_ids" {
  description = "IDs of EC2 instances in ASG"
  value = data.aws_instances.ec2_instances.ids
}

output "ec2_instance_private_ips" {
  description = "Private IPs of EC2 instances"
  value = data.aws_instances.ec2_instances.private_ips
}
 */

/* output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.no-cost-alb.dns_name
} */

output "alb_url" {
  description = "ALB URL"
  value       = "http://${aws_lb.no-cost-alb.dns_name}"
}

output "ec2_endpoint" {
  description = "EC2 endpoint via ALB"
  value       = "http://${aws_lb.no-cost-alb.dns_name}/ec2"
}

output "ecs_endpoint" {
  description = "ECS endpoint via ALB"
  value       = "http://${aws_lb.no-cost-alb.dns_name}/ecs"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.no-cost-app_cluster.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app_service.name
}

/* output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app_alb.dns_name
} */

/* 
output "ec2_asg_name" {
  description = "Name of EC2 Auto Scaling Group"
  value       = aws_autoscaling_group.ec2_asg.name
}

output "ec2_asg_min_size" {
  description = "Minimum number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.min_size
}

output "ec2_asg_max_size" {
  description = "Maximum number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.max_size
}

output "ec2_asg_desired_capacity" {
  description = "Desired number of EC2 instances"
  value       = aws_autoscaling_group.ec2_asg.desired_capacity
}

output "ec2_launch_template_id" {
  description = "Launch template ID for EC2 ASG"
  value       = aws_launch_template.ec2_lt.id
}

output "alb_url" {
  description = "URL to access the application"
  #value       = "http://${aws_lb.app_alb.dns_name}"
  value       = "http://${aws_lb.no-cost-alb.dns_name}"
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}  */