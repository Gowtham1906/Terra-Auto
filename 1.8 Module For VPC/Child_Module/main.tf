module "vpc" {
  source = "../Parent_Module"

  vpc_configs = var.vpc_configs
  subnet_configs         = { for k, v in var.subnet_configs : k => v if v.vpc_key != "Default_VPC" }
  nat_gateway_configs    = { for k, v in var.nat_gateway_configs : k => v if v.vpc_key != "Default_VPC" }
  security_group_configs = { for k, v in var.security_group_configs : k => v if v.vpc_key != "Default_VPC" }
  igw_configs            = { for k, v in var.igw_configs : k => v if v.vpc_key != "Default_VPC" }
  route_table_configs    = { for k, v in var.route_table_configs : k => v if v.vpc_key != "Default_VPC" }
}
