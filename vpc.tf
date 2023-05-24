# VPC
resource "aws_vpc" "this_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.tags}-vpc-tf"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.this_vpc.id
  availability_zone = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tags}-public-sub-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.this_vpc.id
  availability_zone = var.private_subnet_azs[count.index]
  tags = {
    Name = "${var.tags}-private-sub-${count.index + 1}"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.this_vpc.id
  tags = {
    Name = "${var.tags}-IGW-tf"
  }
}

# Create NAT gateway
resource "aws_eip" "example_eip" {
  vpc = true
  tags = {
    Name = "${var.tags}-eip-tf"
  }
}

resource "aws_nat_gateway" "example_nat_gateway" {
  allocation_id = aws_eip.example_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    Name = "${var.tags}-nat-tf"
  }
}

# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this_vpc.id
  tags = {
    Name = "${var.tags}-public-rt-tf"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this_vpc.id
  tags = {
    Name = "${var.tags}-private-rt-tf"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example_nat_gateway.id
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
