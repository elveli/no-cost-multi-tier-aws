# Public Route Table
resource "aws_route_table" "no-cost-public-rt" {
  vpc_id = aws_vpc.no-cost-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.no-cost-igw.id
  }

  tags = {
    Name = "no-cost-public-rt"
  }
}

resource "aws_route_table_association" "no-cost-public-rt-assoc" {
  for_each = aws_subnet.no-cost-public-sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.no-cost-public-rt.id
}

/* # Private Route Table
resource "aws_route_table" "no-cost-private-rt" {
  vpc_id = aws_vpc.no-cost-main.id

  tags = {
    Name = "no-cost-private-rt"
  }
} */

/* resource "aws_route_table_association" "no-cost-private-rt-assoc" {
  for_each = aws_subnet.no-cost-private-sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.no-cost-private-rt.id
} */

/* resource "aws_route" "private-rt-nat-route" {
  count = length(aws_subnet.private-sub)

  route_table_id = aws_route_table.no-cost-private-rt[count.index].id
  nat_gateway_id = aws_nat_gateway.no-cost-nat-gw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}
 */