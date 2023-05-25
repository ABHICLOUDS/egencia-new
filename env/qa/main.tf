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
  source            = "../../modules/vpc"
  appname=var.appname
  env=var.env
  tags = var.tags
  vpc_cidr_block    = var.vpc_cidr_block
  public_subnet_cidr_blocks=var.public_subnet_cidr_blocks
  public_subnet_azs=var.public_subnet_azs
  private_subnet_cidr_blocks=var.private_subnet_cidr_blocks
  private_subnet_azs=var.private_subnet_azs
}

module "ec-2" {
  source            = "../../modules/ec-2"
  vpc_id=module.vpc.vpc_id
  bucket_name=var.bucket_name
  bucket_pl_script=var.bucket_pl_script
  pl_count=var.pl_count
  il_count=var.il_count
  ami_id=var.ami_id
  instance_type=var.instance_type
  key_name=var.key_name
  ebs_volume=var.ebs_volume
  ebs_volume_type=var.ebs_volume_type
  instance_profile_name=var.instance_profile_name
  sg_port=var.sg_port

}