# VPC creation
resource "aws_vpc" "my_vpc" {
  for_each = var.vpc_configs
  
  cidr_block           = each.value.cidr_block
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  tags                 = each.value.tags
}

# Subnet creation
resource "aws_subnet" "my_subnet" {
  for_each = var.subnet_configs
  
  vpc_id            = aws_vpc.my_vpc[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags             = each.value.tags
}

# Internet Gateway creation (based on igw_configs)
resource "aws_internet_gateway" "my_igw" {
  for_each = var.igw_configs
  vpc_id   = aws_vpc.my_vpc[each.value.vpc_key].id
  tags     = each.value.tags
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  for_each = var.nat_gateway_configs
  tags     = each.value.tags
}

# NAT Gateway creation (based on nat_gateway_configs)
resource "aws_nat_gateway" "my_nat_gw" {
  for_each = var.nat_gateway_configs
  
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.my_subnet[each.value.public_subnet_key].id
  tags          = each.value.tags
}

# Route Table creation (based on route_table_configs)
resource "aws_route_table" "my_route_table" {
  for_each = var.route_table_configs
  vpc_id   = aws_vpc.my_vpc[each.value.vpc_key].id
  tags     = each.value.tags
}

# Route creation (for internet access using Internet Gateway)
resource "aws_route" "my_route" {
  for_each = var.route_table_configs

  route_table_id         = aws_route_table.my_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw["igw"].id
}

# Security Group creation (based on security_group_configs)
resource "aws_security_group" "my_sg" {
  for_each = var.security_group_configs
  
  vpc_id = aws_vpc.my_vpc[each.value.vpc_key].id
  name   = each.value.name
  tags   = each.value.tags
}
