resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.vpc
  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-sg"
  })
}

resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  type = "ingress"

  protocol  = each.value.protocol
  to_port   = each.value.to_port
  from_port = each.value.from_port

  cidr_blocks      = each.value.cidr_blocks
  ipv6_cidr_blocks = each.value.ipv6_cidr_blocks

  security_group_id = each.value.security_group_id
}

resource "aws_security_group_rule" "egress" {
  for_each = var.ingress_rules

  type = "egress"

  protocol  = each.value.protocol
  to_port   = each.value.to_port
  from_port = each.value.from_port

  cidr_blocks      = each.value.cidr_blocks
  ipv6_cidr_blocks = each.value.ipv6_cidr_blocks

  security_group_id = each.value.security_group_id
}
