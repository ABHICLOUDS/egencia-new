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

module "ec2" {
  source                     = "../../modules/ec-2"
  vpc_id                     = module.vpc.vpc_id
  bucket_name                = var.bucket_name
  bucket_pl_script           = var.bucket_pl_script
  pl_count                   = var.pl_count
  il_count                   = var.il_count
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  key_name                   = var.key_name
  ebs_volume                 = var.ebs_volume
  ebs_volume_type            = var.ebs_volume_type
  instance_profile_name      = var.instance_profile_name
  sg_port                    = var.sg_port
  appname                    = var.appname
  env                        = var.env
  tags                       = var.tags
  public_subnet_ids     = module.vpc.public-subnet
  private_subnet_ids    = module.vpc.private-subnet
}

# Internet-facing (PL) load balancer
module "pl_lb" {
  source = "../../modules/alb"

  alb_name               = "${var.tags["Name"]}-example-pl-lb"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.example.id]
  subnets                = module.vpc.public_subnet

  target_group_name      = "${var.tags["Name"]}-example-pl-tg"
  target_group_port      = var.tg_port
  target_group_protocol  = var.tg_protocol
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = var.pl_hc_path
  listener_port          = var.pl_listener_port
  listener_protocol      = var.pl_listener_protocol
  target_count           = var.pl_count
  target_ids             = module.ec2.pl_instance_ids
  target_port            = var.pl_tg_attach_port
}

# Internal (IL) load balancer
module "il_lb" {
  source = "../../modules/alb"

  alb_name               = "${var.tags["Name"]}-example-il-lb"
  internal               = true
  load_balancer_type     = "application"
  security_groups        = [aws_security_group.example.id]
  subnets                = module.vpc.private_subnet

  target_group_name      = "${var.tags["Name"]}-example-il-tg"
  target_group_port      = var.tg_port
  target_group_protocol  = var.tg_protocol
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = var.il_hc_path
  listener_port          = var.il_listener_port
  listener_protocol      = var.il_listener_protocol
  target_count           = var.il_count
  target_ids             = module.ec2.il_instance_ids
  target_port            = var.il_tg_attach_port
}

