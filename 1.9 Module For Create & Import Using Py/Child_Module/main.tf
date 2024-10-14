module "vpc" {
  source = "../Parent_Module"

  vpc_configs            = var.vpc_configs
  subnet_configs         = var.subnet_configs
  nat_gateway_configs    = var.nat_gateway_configs 
  security_group_configs = var.security_group_configs
  igw_configs            = var.igw_configs 
  route_table_configs    = var.route_table_configs 
}

