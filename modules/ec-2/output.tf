output "pl_count" {
  value = var.pl_count
}

output "il_count" {
  value = var.il_count
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "il_instance_ids" {
  value = aws_instance.example_instances-2.*.id
}