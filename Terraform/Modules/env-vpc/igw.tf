resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id


  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-igw"
  })
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-route-table"
  })
}

resource "aws_route" "route" {
  for_each = var.routes

  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = each.value.cidr_block
  gateway_id             = each.value.gateway_id
  nat_gateway_id         = each.value.nat_gateway_id
  network_interface_id   = each.value.network_interface_id
}
