resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id


  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-igw"
  })
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = merge(var.tags, {
    Name = "${var.deploy_env}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [aws_internet_gateway.igw]

  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id

  subnet_id = aws_subnet.subnet[index(var.subnet_types, "public")].id
  tags = merge(var.tags, {
    Terraform = "true"
    Name      = "${var.deploy_env}-nat"
  })
}

resource "aws_route" "priavte_nat_route" {
  count                  = var.create_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0" // all outbound IPs
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-public-route-table"
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-private-route-table"
  })
}

resource "aws_route" "public_route" {
  for_each = var.public_routes

  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = each.value.cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  network_interface_id   = each.value.network_interface_id
}

resource "aws_route" "private_route" {
  for_each = var.private_routes

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = each.value.cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  network_interface_id   = each.value.network_interface_id
}

resource "aws_route_table_association" "public_route_table_association" {

  for_each       = { for i, type in var.subnet_types : i => type if type == "public" }
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = { for i, type in var.subnet_types : i => type if type == "private" }
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}
