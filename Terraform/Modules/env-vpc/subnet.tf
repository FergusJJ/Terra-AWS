/*
  want to avoid having private-subnet-1, public-subnet-2 for [private, public]
  instead this should only increment subnet indexes if the same type as
  the others
*/
locals {
  subnet_with_type_index = {
    for i in range(length(var.subnet_cidrs)) :
    i => {
      cidr_block        = var.subnet_cidrs[i]
      availability_zone = var.azs[i % length(var.azs)]
      type              = var.subnet_types[i]
      type_idx = length([
        for j in range(i + 1) :
        var.subnet_types[j] if var.subnet_types[j] == var.subnet_types[i]
      ])
    }
  }
}

resource "aws_subnet" "subnet" {
  for_each = local.subnet_with_type_index

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-${each.value.type}-subnet-${each.value.type_idx}"
  })
}
