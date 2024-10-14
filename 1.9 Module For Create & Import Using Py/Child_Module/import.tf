
resource "aws_vpc" "imported_vpc" {
  cidr_block = "192.0.0.0/24"
  tags = {
  "Name": "test_vpc"
}
}











