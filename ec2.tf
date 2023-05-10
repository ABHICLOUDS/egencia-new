# Create EC2 instance
resource "aws_instance" "example_instance-1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.example_sg1.id]
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
  vpc_security_group_ids      = [aws_security_group.example_sg2.id]
  iam_instance_profile        = var.instance_profile_name
  tags = {
    Name = "${var.tags}-il-instance-tf"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_security_group" "example_sg1" {
  name_prefix = "example_sg1"
  vpc_id      = aws_vpc.example_vpc.id
}

resource "aws_security_group" "example_sg2" {
  name_prefix = "example_sg2"
  vpc_id      = aws_vpc.example_vpc.id
}

# Allow all traffic from example_sg2 to example_sg1
resource "aws_security_group_rule" "sg2_to_sg1" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = [aws_security_group.example_sg2.id]
  security_group_id = aws_security_group.example_sg1.id
}

# Allow all traffic from example_sg1 to example_sg2
resource "aws_security_group_rule" "sg1_to_sg2" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = [aws_security_group.example_sg1.id]
  security_group_id = aws_security_group.example_sg2.id
}
