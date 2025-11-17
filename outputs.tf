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
  value       = aws_lb.no-cost-app-alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "instance_public_ip" {
  value       = aws_instance.no-cost-app.public_ip
  description = "Public IP of the EC2 instance"
}
