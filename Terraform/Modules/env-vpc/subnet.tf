resource "aws_subnet" "subnet" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-subnet-${count.index + 1}"
  })
}
