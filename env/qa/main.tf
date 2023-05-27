terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0.0"
    }
  }
}

# main.tf

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                    = "../../modules/vpc"
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  private_subnet_azs        = var.private_subnet_azs
  public_subnet_azs         = var.public_subnet_azs
  appname                   = var.appname
  env                       = var.env
  tags                      = var.tags
}

module "ec2" {
  source  = "../../modules/ec2"
  # Pass module-specific variables here
  appname          = var.appname
  env              = var.env
  bucket_name      = var.bucket_name
  bucket_pl_script = var.bucket_pl_script
  sg_port          = var.sg_port
  pl_count         = var.pl_count
  il_count         = var.il_count
  instance_type    = var.instance_type
  ami_id           = var.ami_id
  key_name         = var.key_name
  instance_profile_name = var.instance_profile_name
  ebs_volume       = var.ebs_volume
  ebs_volume_type  = var.ebs_volume_type
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  tags                      = var.tags
}

module "pl_alb" {
  source  = "../../modules/alb"
  # Pass module-specific variables here
  alb_name               = var.pl_alb_name
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [module.ec2.sg_id]
  subnets                = module.vpc.public_subnet_ids
  target_group_name      = var.pl_tg_name
  target_group_port      = var.pl_tg_port
  target_group_protocol  = var.pl_tg_protocol
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = var.pl_hc_path
  listener_port          = var.pl_listener_port
  listener_protocol      = var.pl_listener_protocol
  target_count           = module.ec2.pl_count
  target_ids             = module.ec2.pl_instance_ids
  target_port            = var.pl_tg_attach_port
}

module "il_alb" {
  source  = "../../modules/alb"
  # Pass module-specific variables here
  alb_name               = var.il_alb_name
  internal               = true
  load_balancer_type     = "application"
  security_groups        = [module.ec2.sg_id]
  subnets                = module.vpc.private_subnet_ids
  target_group_name      = var.il_tg_name
  target_group_port      = var.il_tg_port
  target_group_protocol  = var.il_tg_protocol
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = var.il_hc_path
  listener_port          = var.il_listener_port
  listener_protocol      = var.il_listener_protocol
  target_count           = module.ec2.il_count
  target_ids             = module.ec2.il_instance_ids
target_port              = var.il_tg_attach_port
}



