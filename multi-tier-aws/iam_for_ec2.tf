# IAM role for backend EC2 to read secrets
resource "aws_iam_role" "backend_role" {
  name = "backend-secrets-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
  tags = { Name = "backend-role" }
}

resource "aws_iam_policy" "backend_secrets_policy" {
  name        = "backend-secrets-access"
  description = "Allow read access to DB secret"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
      Resource = aws_secretsmanager_secret.db_secret.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets_policy" {
  role       = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.backend_secrets_policy.arn
}

resource "aws_iam_instance_profile" "backend_profile" {
  name = "backend-instance-profile"
  role = aws_iam_role.backend_role.name
}

