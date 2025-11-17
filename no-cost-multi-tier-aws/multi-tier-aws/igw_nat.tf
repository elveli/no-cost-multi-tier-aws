resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "igw" }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = { Name = "nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-sub[0].id
  tags = { Name = "nat" }
}

# Public route table
resource "aws_route_table" "public-sub" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-rt" }
}
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public-sub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public-sub)
  subnet_id      = aws_subnet.public-sub[count.index].id
  route_table_id = aws_route_table.public-sub.id
}

# Private route table (uses NAT)
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private-rt" }
}
resource "aws_route" "private_default-rt" {
  route_table_id         = aws_route_table.private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private-sub)
  subnet_id      = aws_subnet.private-sub[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

# DB subnet route table - no internet access (isolated)
resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "db-rt" }
}
resource "aws_route_table_association" "db_assoc" {
  count          = length(aws_subnet.db-sub)
  subnet_id      = aws_subnet.db-sub[count.index].id
  route_table_id = aws_route_table.db-rt.id
}

