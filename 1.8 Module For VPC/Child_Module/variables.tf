variable "vpc_configs" {
  description = "Map of VPC configurations to create"
  type = map(object({
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    tags                 = map(string)
  }))
}

variable "subnet_configs" {
  description = "Map of Subnet configurations to create"
  type = map(object({
    vpc_key                = string
    cidr_block             = string
    availability_zone      = string
    map_public_ip_on_launch = bool
    tags                   = map(string)
  }))
}

variable "nat_gateway_configs" {
  description = "Map of NAT Gateway configurations"
  type = map(object({
    vpc_key           = string
    public_subnet_key = string
    tags              = map(string)
  }))
}

variable "security_group_configs" {
  description = "Map of security group configurations"
  type = map(object({
    vpc_key = string
    name    = string
    tags    = map(string)
  }))
}

variable "igw_configs" {
  description = "Map of Internet Gateway configurations"
  type = map(object({
    vpc_key = string
    tags    = map(string)
  }))
}

variable "route_table_configs" {
  description = "Map of Route Table configurations"
  type = map(object({
    vpc_key = string
    routes  = list(object({
      cidr_block = string
      gateway_id = string
    }))
    tags    = map(string)
  }))
}

