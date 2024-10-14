provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

resource "aws_vpc" "my_vpc_1" {
  provider   = aws.us_east_1
  cidr_block = "10.0.0.0/24"
}

resource "aws_vpc" "my_vpc_2" {
  provider   = aws.us_east_2
  cidr_block = "10.2.0.0/24"
}
