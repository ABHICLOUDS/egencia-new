data "aws_s3_object" "user_data_script" {
  bucket = var.bucket_name
  key    = var.bucket_pl_script
}

resource "aws_instance" "example_instances" {
  count                       = var.pl_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.public_subnets.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.example_sg1.id, aws_security_group.example.id]
  iam_instance_profile        = var.instance_profile_name
  user_data                   = data.aws_s3_object.user_data_script.body
  tags = {
    Name      = "${var.tags}-pl-instance${count.index + 1}-tf"
  }
  root_block_device {
    volume_size = var.ebs_volume
    volume_type = var.ebs_volume_type
  }
}

resource "aws_instance" "example_instance-2" {
  count                  = var.il_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = element(aws_subnet.private_subnets.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.example_sg2.id,aws_security_group.example.id]
  iam_instance_profile   = var.instance_profile_name
  tags = {
    Name = "${var.tags}-il-instance-tf"
  }
  root_block_device {
    volume_size = var.ebs_volume
    volume_type = var.ebs_volume_type
  }
}

resource "aws_security_group" "example_sg1" {
  name_prefix = "example_sg1"
  vpc_id      = aws_vpc.this_vpc.id
  tags = {
    Name = "${var.tags}-pl-sg-tf"
  }
}

resource "aws_security_group" "example_sg2" {
  name_prefix = "example_sg2"
  vpc_id      = aws_vpc.this_vpc.id
  tags = {
    Name = "${var.tags}-il-sg-tf"
  }
}
#data "aws_security_group" "example_sg3" {
#  id = "sg-0097dd712ff81570b"
#}

#resource "aws_security_group_rule" "sg1_to_sg3_ingress" {
#  type                     = "ingress"
#  from_port                = 0
#  to_port                  = 0
#  protocol                 = "-1"
#  security_group_id       = aws_security_group.example_sg1.id
#  source_security_group_id = data.aws_security_group.example_sg3.id
#}

#resource "aws_security_group_rule" "sg2_to_sg3_ingress" {
#  type                     = "ingress"
#  from_port                = 0
#  to_port                  = 0
#  protocol                 = "-1"
#  security_group_id       = aws_security_group.example_sg2.id
#  source_security_group_id = data.aws_security_group.example_sg3.id
#}

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


resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = aws_vpc.this_vpc.id
  dynamic "ingress" {
    for_each = var.sg_port
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}