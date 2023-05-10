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


resource "aws_security_group" "example_sg-1" {
  name_prefix = "${var.tags}-pl-sg-tf"
  vpc_id      = aws_vpc.example_vpc.id
  dynamic "ingress" {
    for_each = [22, 80, 8080, 443]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tags}-pl-sg-tf"
  }
}

resource "aws_security_group" "example_sg-2" {
  name_prefix = "${var.tags}-il-sg-tf"
  vpc_id      = aws_vpc.example_vpc.id
  dynamic "ingress" {
    for_each = [22, 80, 8080, 443]
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tags}-il-sg-tf"
  }
}