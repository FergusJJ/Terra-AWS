variable "HOME_MAC" {
  type = string
}

module "infra_vpc" {
  source = "../../Modules/env-vpc"

  deploy_env         = "infra"
  vpc_cidr           = "10.0.0.0/16"
  azs                = ["eu-west-2a"]
  subnet_cidrs       = ["10.0.1.0/24", "10.0.10.0/24"]
  subnet_types       = ["public", "private"]
  create_nat_gateway = true
  //no VPCs setup so no peering connections
  ingress_rules = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress_rules = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}
