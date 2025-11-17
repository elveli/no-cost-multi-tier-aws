/* locals {
  private_to_public_map = {
    "no-cost-private-subnet-1" = "no-cost-public-subnet-1"
    "no-cost-private-subnet-2" = "no-cost-public-subnet-2"
  }
} */

# Elastic IPs for NAT Gateways (one per public subnet)
resource "aws_eip" "no-cost-nat-eip" {
  for_each = aws_subnet.no-cost-public-sub

  #vpc = true

  tags = merge({ Name = "no-cost-nat-eip-${each.key}" }, var.common_tags)
}

# NAT Gateways - one per public subnet (keyed same as public subnets)
resource "aws_nat_gateway" "no-cost-nat-gw" {
  for_each     = aws_subnet.no-cost-public-sub
  allocation_id = aws_eip.no-cost-nat-eip[each.key].id
  subnet_id     = each.value.id

  tags = merge({ Name = "no-cost-nat-gw-${each.key}" }, var.common_tags)

  depends_on = [aws_internet_gateway.no-cost-igw]
}

# Private route table per private subnet (keyed same as private subnets)
resource "aws_route_table" "no-cost-private-rt" {
  for_each = aws_subnet.no-cost-private-sub
  vpc_id   = aws_vpc.no-cost-main.id

  tags = merge({ Name = "no-cost-private-rt-${each.key}" }, var.common_tags)
}

# Associate private subnets with their route tables
resource "aws_route_table_association" "no-cost-private-rt-assoc" {
  for_each = aws_subnet.no-cost-private-sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.no-cost-private-rt[each.key].id
}

# Add default route in each private route table pointing to the NAT in same AZ
#resource "aws_route" "no-cost-private-rt-nat-route" {
 # for_each = aws_subnet.no-cost-private-sub

  #route_table_id         = aws_route_table.no-cost-private-rt[each.key].id
  #destination_cidr_block = "0.0.0.0/0"

  # use mapping to find the corresponding public subnet key and then the NAT gw
/*   nat_gateway_id = aws_nat_gateway.no-cost-nat-gw[
    local.private_to_public_map[each.key]
  ].id
 */  
  ##nat_gateway_id = aws_nat_gateway.no-cost-nat-gw[each.key].id

#}

resource "aws_route" "no-cost-private-rt-nat-route" {
  for_each = aws_route_table.no-cost-private-rt

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.no-cost-nat-gw[local.private_to_public_map[each.key]].id
}

