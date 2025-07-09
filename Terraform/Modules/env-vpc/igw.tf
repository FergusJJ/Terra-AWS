resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id


  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-igw"
  })
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

resource "aws_route" "private_routes" {
  for_each = var.private_routes

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = each.value.cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  network_interface_id   = each.value.network_interface_id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length([for i, type in var.subnet_types : i if type == "public"])
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length([for i, type in var.subnet_types : i if type == "private"])
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
