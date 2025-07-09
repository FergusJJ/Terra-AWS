resource "aws_subnet" "subnet" {
  count                   = length(var.subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = element(var.subnet_types, count.index) == "public" ? true : false

  tags = merge(var.tags, {
    Terraform   = "true"
    Environment = var.deploy_env
    Name        = "${var.deploy_env}-${element(var.subnet_types, count.index)}-subnet-${count.index + 1}"
  })
}
