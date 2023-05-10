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
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [aws_security_group.example_sg2.id]
  iam_instance_profile   = var.instance_profile_name
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

resource "aws_security_group_rule" "sg1_to_sg2_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.example_sg2.id
  source_security_group_id = aws_security_group.example_sg1.id
}

resource "aws_security_group_rule" "sg1_to_sg2_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.example_sg1.id
  source_security_group_id = aws_security_group.example_sg2.id
}

resource "aws_security_group_rule" "sg2_to_sg1_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.example_sg1.id
  source_security_group_id = aws_security_group.example_sg2.id
}

resource "aws_security_group_rule" "sg2_to_sg1_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.example_sg2.id
  source_security_group_id = aws_security_group.example_sg1.id
}

