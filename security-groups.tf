# Public SG
resource "aws_security_group" "no-cost-public-sg" {
  name        = "no-cost-public-sg"
  description = "Allow HTTP, HTTPS, SSH from anywhere"
  vpc_id      = aws_vpc.no-cost-main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "no-cost-public-sg"
  }
}

# Private SG
resource "aws_security_group" "no-cost-private-sg" {
  name        = "no-cost-private-sg"
  description = "Allow traffic from public SG only"
  vpc_id      = aws_vpc.no-cost-main.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.no-cost-public-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge (
    { Name = "no-cost-private-sg" },
    var.common_tags
    )
  }

