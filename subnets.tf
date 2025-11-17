# Public subnets
resource "aws_subnet" "no-cost-public-sub" {
  for_each = { for s in local.public_subnet_info : s.name => s }

  vpc_id                  = aws_vpc.no-cost-main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.name
  }
}

# Private subnets
resource "aws_subnet" "no-cost-private-sub" {
  for_each = { for s in local.private_subnet_info : s.name => s }

  vpc_id            = aws_vpc.no-cost-main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

