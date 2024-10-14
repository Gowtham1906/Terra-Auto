provider "aws" {
  region = var.region
}

# Create VPC1 and VPC2
module "vpc" {
  source     = "../Parent-Module"
  for_each   = { for k, v in var.vpcs : k => v if k != "Default_VPC" }
  cidr_block = each.value.cidr_block
  vpc_name   = each.key
}

# Do not create Default VPC, only import it
resource "aws_vpc" "default_vpc" {
  for_each = { Default_VPC = var.vpcs["Default_VPC"] }

  cidr_block = each.value.cidr_block

  tags = {
    Name = "Default_VPC"
  }
}

