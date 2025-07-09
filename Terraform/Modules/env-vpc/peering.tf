resource "aws_vpc_peering_connection" "peering_connection" {
  for_each    = var.peering_connections
  peer_vpc_id = each.value.peer_vpc_id
  vpc_id      = each.value.vpc_id
  auto_accept = each.value.auto_accept

}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_connection_accepter" {
  depends_on                = [aws_vpc_peering_connection.peering_connection]
  for_each                  = var.peering_connection_accepters
  vpc_peering_connection_id = each.value.vpc_peering_connection_id
  auto_accept               = each.value.auto_accept
}
