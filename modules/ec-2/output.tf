output "pl_count" {
  value = var.pl_count
}

output "il_count" {
  value = var.il_count
}

output "pl_instance_ids" {
  value = aws_instance.example_instances.*.id
}

output "il_instance_ids" {
  value = aws_instance.example_instances-2.*.id
}