provider "aws" {
  region = "us-west-2"  # Specify your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Define your VPC CIDR block

  enable_dns_support = true  # Enable DNS support in the VPC
  enable_dns_hostnames = true  # Enable DNS hostnames in the VPC
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Subnet CIDR block
  availability_zone       = "us-west-2a"  # Specify your AZ
  map_public_ip_on_launch = true  # Enable public IP for instances in this subnet
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"  # Another Subnet CIDR block
  availability_zone       = "us-west-2b"  # Specify your AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id  # Attach Internet Gateway to the VPC
  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id  # Route traffic to the Internet Gateway
  }

  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "subnet_a_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "subnet_b_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.my_route_table.id
}

# Security Group for Public Subnets
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow inbound traffic for public instances"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create NAT Gateway for Private Subnets (Optional)
resource "aws_eip" "my_nat_eip" {
  domain = "vpc"  # Use the 'domain' attribute instead of 'vpc'
}

resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.subnet_a.id
  tags = {
    Name = "my-nat-gateway"
  }
}

# Private Subnet (optional example, adjust as needed)
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false  # Disable public IP for private subnet
  tags = {
    Name = "private-subnet"
  }
}

# Private Route Table with NAT Gateway for outbound traffic
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw.id  # Route traffic via NAT Gateway
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

# Outputs to display key information
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.my_nat_gw.id
}
