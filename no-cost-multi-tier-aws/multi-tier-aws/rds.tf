resource "aws_db_subnet_group" "this" {
  name       = "app-db-subnet-group"
  subnet_ids = aws_subnet.db-sub[*].id
  tags = { Name = "app-db-subnet-group" }
}

resource "aws_db_instance" "db" {
  identifier             = "app-db"
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = random_password.db_pass.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  deletion_protection    = false
  tags = { Name = "app-rds" }
}

