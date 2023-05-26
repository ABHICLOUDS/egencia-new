# outputs.tf (inside VPC module)

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_id" {
  value = aws_vpc.this_vpc.id
}
