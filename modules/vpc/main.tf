# main.tf (inside VPC module)

resource "aws_vpc" "this_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"
  tags       = merge(var.tags, { "Name" = format("%s-%s-vpc", var.appname, var.env) })
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count                  = length(var.public_subnet_cidr_blocks)
  cidr_block             = var.public_subnet_cidr_blocks[count.index]
  vpc_id                 = aws_vpc.this_vpc.id
  availability_zone      = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true
  tags                      = merge(var.tags, { "Name" = format("%s-%s-public-sub-%d", var.appname, var.env, count.index + 1) })
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  vpc_id            = aws_vpc.this_vpc.id
  availability_zone = var.private_subnet_azs[count.index]
  tags                      = merge(var.tags, { "Name" = format("%s-%s-private-sub-%d", var.appname, var.env, count.index + 1) })
}

# Create internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.this_vpc.id
  tags   = merge(var.tags, { "Name" = format("%s-%s-igw-tf", var.appname, var.env) })
}

# Create NAT gateway
resource "aws_eip" "example_eip" {
  vpc  = true
  tags = merge(var.tags, { "Name" = format("%s-%s-nat-tf-eip", var.appname, var.env) })
}

resource "aws_nat_gateway" "example_nat_gateway" {
  allocation_id = aws_eip.example_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags          = merge(var.tags, { "Name" = format("%s-%s-nat-tf", var.appname, var.env) })
}

# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this_vpc.id
  tags   = merge(var.tags, { "Name" = format("%s-%s-public-rt-tf", var.appname, var.env) })

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
  tags   = merge(var.tags, { "Name" = format("%s-%s-private-rt-tf", var.appname, var.env) })

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
