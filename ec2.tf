# Create EC2 instance
resource "aws_instance" "example_instance-1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.example_sg-1.id]
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = "${var.tags}-pl-instance-tf"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_instance" "example_instance-2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.example_sg-2.id]
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = "${var.tags}-il-instance-tf"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}