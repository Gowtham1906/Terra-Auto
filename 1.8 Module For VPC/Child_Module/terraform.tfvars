vpc_configs = {
  "vpc" = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      Name        = "vpc"
      Environment = "production"
    }
  },
  "Default_VPC" = {
    cidr_block           = "172.31.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
      Name        = "Default_VPC"
    }
  }
}

subnet_configs = {
  "sub_pub" = {
    vpc_key           = "vpc"
    cidr_block        = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet"
    }
  },
  "sub_pri" = {
    vpc_key           = "vpc"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
      Name = "private-subnet"
    }
  }
}

nat_gateway_configs = {
  "nat" = {
    vpc_key           = "vpc"
    public_subnet_key = "sub_pub"
    tags              = {
      Name = "nat-gateway"
    }
  }
}

security_group_configs = {
  "sg" = {
    vpc_key = "vpc"
    name    = "web-sg"
    tags    = {
      Name = "web-sg"
    }
  }
}

igw_configs = {
  "igw" = {
    vpc_key = "vpc"
    tags    = {
      Name = "internet-gateway"
    }
  }
}

route_table_configs = {
  "rt_pub" = {
    vpc_key = "vpc"
    routes = [
      {
        cidr_block = "0.0.0.0/0"
        gateway_id = "igw"
      }
    ]
    tags = {
      Name = "public-route-table"
    }
  }
}

