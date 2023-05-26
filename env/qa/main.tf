terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                      = "../../modules/vpc"
  appname                     = var.appname
  env                         = var.env
  tags                        = var.tags
  vpc_cidr_block              = var.vpc_cidr_block
  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  public_subnet_azs           = var.public_subnet_azs
  private_subnet_cidr_blocks  = var.private_subnet_cidr_blocks
  private_subnet_azs          = var.private_subnet_azs
}

module "ec-2" {
  source                      = "../../modules/ec-2"
  vpc_id                      = module.vpc.vpc_id
  bucket_name                 = var.bucket_name
  bucket_pl_script            = var.bucket_pl_script
  pl_count                    = var.pl_count
  il_count                    = var.il_count
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  ebs_volume                  = var.ebs_volume
  ebs_volume_type             = var.ebs_volume_type
  instance_profile_name       = var.instance_profile_name
  sg_port                     = var.sg_port
  appname                     = var.appname
  env                         = var.env
  tags                        = var.tags
  public_subnet_ids           = module.vpc.public_subnet_ids
  private_subnet_ids          = module.vpc.private_subnet_ids
}

# Internet-facing (PL) load balancer
module "pl_lb" {
  source = "../modules/alb"

  name               = "${var.tags["Name"]}-example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example.id]
  subnets            = module.vpc.public_subnet_ids

  target_group_name        = "${var.tags["Name"]}-example-tg"
  target_group_port        = var.tg_port
  target_group_protocol    = var.tg_protocol
  vpc_id                   = module.vpc.vpc_id
  health_check_path        = var.pl_hc_path
  listener_port            = var.pl_listener_port
  listener_protocol        = var.pl_listener_protocol
  target_count             = module.ec-2.pl_count
  target_ids               = aws_instance.example_instances[*].id
  target_port              = var.pl_tg_attach_port

  tags = var.tags
}

# Internal (IL) load balancer
module "il_lb" {
  source = "../modules/alb"

  name               = "${var.tags["Name"]}-example-ilb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example.id]
  subnets            = module.vpc.private_subnet_ids
  target_group_name        = "${var.tags["Name"]}-example-itg"
  target_group_port        = var.tg_port
  target_group_protocol    = var.tg_protocol
  vpc_id                   = module.vpc.vpc_id
  health_check_path        = var.il_hc_path
  listener_port            = var.il_listener_port
  listener_protocol        = var.il_listener_protocol
  target_count             = module.ec-2.il_count
  target_ids               = aws_instance.example_instances-2[*].id
  target_port              = var.il_tg_attach_port
  tags = var.tags
}
