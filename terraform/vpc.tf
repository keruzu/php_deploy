
resource "aws_subnet" "public_subneta" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidr_blocks, 0)
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "public_subnetb" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidr_blocks, 1)
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidr_blocks, 0)
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subneta.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Main VPC"
  }
}

