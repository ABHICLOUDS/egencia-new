output "public-subnet" {
  value=aws_subnet.public_subnets[*].id
}

output "private-subnet" {
  value=aws_subnet.private_subnets[*].id
}

output "vpc_id" {
  value=aws_vpc.this_vpc.id
}