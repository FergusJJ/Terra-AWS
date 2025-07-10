resource "aws_vpc_peering_connection" "peering_connection" {
  for_each = var.peering_connections

  peer_vpc_id = each.value.peer_vpc_id
  vpc_id      = aws_vpc.vpc.id
  auto_accept = each.value.auto_accept

  tags = merge(var.tags, {
    Name = "${var.deploy_env}-to-${each.key}-peering"
  })
}

resource "aws_vpc_peering_connection_options" "peering_options" {
  for_each                  = var.peering_connections
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection[each.key].id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_connection_accepter" {
  depends_on                = [aws_vpc_peering_connection.peering_connection]
  for_each                  = var.peering_connection_accepters
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
  auto_accept               = each.value.auto_accept
}
