# main.tf (inside EC2 module)

data "aws_s3_object" "user_data_script" {
  bucket = var.bucket_name
  key    = var.bucket_pl_script
}

resource "aws_instance" "example_instances" {
  count                     = var.pl_count
  ami                       = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  subnet_id                 = element(var.public_subnet_ids, count.index)
  vpc_security_group_ids    = [aws_security_group.example_sg1.id, aws_security_group.example.id]
  iam_instance_profile      = var.instance_profile_name
  user_data                 = data.aws_s3_object.user_data_script.body
  tags = merge(var.tags, { "Name" = format("%s-%s-pl-instance-%d", var.appname, var.env, count.index + 1) })

  root_block_device {
    volume_size = var.ebs_volume
    volume_type = var.ebs_volume_type
  }
}

resource "aws_instance" "example_instance_2" {
  count                     = var.il_count
  ami                       = var.ami_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  subnet_id                 = element(var.private_subnet_ids, count.index)
  vpc_security_group_ids    = [aws_security_group.example_sg2.id, aws_security_group.example.id]
  iam_instance_profile      = var.instance_profile_name
  tags = merge(var.tags, { "Name" = format("%s-%s-il-instance-%d", var.appname, var.env, count.index + 1) })
  root_block_device {
    volume_size = var.ebs_volume
    volume_type = var.ebs_volume_type
  }
}

resource "aws_security_group" "example_sg1" {
  name_prefix = "example_sg1"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { "Name" = format("%s-%s-pl-sg-tf", var.appname, var.env) }) 
}

resource "aws_security_group" "example_sg2" {
  name_prefix = "example_sg2"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { "Name" = format("%s-%s-il-sg-tf", var.appname, var.env) })
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

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"
  vpc_id      = var.vpc_id

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
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}