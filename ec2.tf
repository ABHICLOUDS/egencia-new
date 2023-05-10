# Create EC2 instance
resource "aws_instance" "example_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = "${var.tags}-instance-tf"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}
