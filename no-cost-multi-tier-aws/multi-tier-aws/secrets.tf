# random password for RDS master
resource "random_password" "db_pass" {
  length  = 16
  special = true
}

# create secret in Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "app/db/master"
  description = "DB master credentials for app RDS"
  tags = { Name = "app-db-secret" }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_pass.result
  })
}

