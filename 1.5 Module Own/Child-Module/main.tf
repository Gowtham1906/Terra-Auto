provider "aws" {
  region = region
}

module "my-vpc" {
  source              = "../Parent-Module"
  region              = var.region
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidr  = var.public_subnet_cidr
  availability_zone   = var.availability_zone
}

