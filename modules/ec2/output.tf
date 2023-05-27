# outputs.tf (inside EC2 module)

output "pl_count" {
  value = var.pl_count
}

output "il_count" {
  value = var.il_count
}

output "sg_id" {
  value = aws_security_group.example.id
}

output "pl_instance_ids" {
  value = aws_instance.example_instances[*].id
}

output "il_instance_ids" {
  value = aws_instance.example_instance_2[*].id
}

