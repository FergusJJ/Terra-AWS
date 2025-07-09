

// vpc.tf
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Whether the VPC has DNS hostnames enabled"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Whether the VPC has DNS support enabled"
  type        = bool
  default     = true
}

// subnet.tf

variable "azs" {
  description = "The availability zones"
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the subnet"
  type        = list(string)
}

variable "subnet_types" {
  description = "Subnet types corresponding to subnet CIDRs ('public'/'private')"
  type        = list(string)
  validation {
    condition     = alltrue([for t in var.subnet_types : contains(["public", "private"], t)])
    error_message = "Subnet types must be either 'public' or 'private'."
  }
}
//igw.tf

variable "create_nat_gateway" {
  description = "Whether to create a NAT gateway"
  type        = bool
}

variable "public_routes" {
  description = "A list of public routes (cidr_block, network_interface_id)"
  type = map(object({
    cidr_block           = string
    gateway_id           = optional(string)
    nat_gateway_id       = optional(string)
    network_interface_id = optional(string)
    })
  )
  default = {}
}

variable "private_routes" {
  description = "A list of private routes (cidr_block, network_interface_id)"
  type = map(object({
    cidr_block           = string
    gateway_id           = optional(string)
    nat_gateway_id       = optional(string)
    network_interface_id = optional(string)
    })
  )
  default = {}
}

//security.tf

variable "egress_rules" {
  description = "List of egress rules"
  type = map(object({
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_group_id = string
    self              = optional(bool, false)
    description       = optional(string, "")
  }))
  default = {}
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = map(object({
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string), [])
    ipv6_cidr_blocks  = optional(list(string), [])
    security_group_id = string
    self              = optional(bool, false)
    description       = optional(string, "")
  }))
  default = {}
}

// peering.tf

variable "peering_connections" {
  description = "List of peering connections"
  type = map(object({
    vpc_id      = string
    peer_vpc_id = string
    auto_accept = optional(string, false) //think is required to be false
  }))
  default = {}
}

variable "peering_connection_accepters" {
  description = "List of peering connection accepters"
  type = map(object({
    vpc_peering_connection_id = string
    auto_accept               = optional(bool, false)
  }))
  default = {}
}

// shared

variable "deploy_env" {
  description = "The environment which the VPC is deployed"
  type        = string

}
variable "tags" {
  description = "Tags to merge with VPC"
  type        = map(string)
  default     = {}
}
