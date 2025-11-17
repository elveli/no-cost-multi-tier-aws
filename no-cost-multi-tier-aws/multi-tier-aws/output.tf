output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public-sub[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private-sub[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db-sub[*].id
}

output "alb_dns" {
  value = aws_lb.app.dns_name
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.db.address
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

