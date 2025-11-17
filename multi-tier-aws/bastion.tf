data "aws_ami" "amazon_linux_2_bastion" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux_2_bastion.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-sub[0].id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.bastion.key_name
  associate_public_ip_address = true
  tags = { Name = "bastion" }
}

output "bastion_public_ip" {
  description = "Bastion public IP"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_key_pem" {
  description = "Private key PEM for bastion (sensitive)"
  value       = tls_private_key.bastion_key.private_key_pem
  sensitive   = true
}

