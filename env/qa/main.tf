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
  source            = "../../modules"
  tags = var.tags
  vpc_cidr_block    = var.vpc_cidr_block
  public_subnet_cidr_blocks=var.public_subnet_cidr_blocks
  public_subnet_azs=var.public_subnet_azs
  private_subnet_cidr_blocks=var.private_subnet_cidr_blocks
  private_subnet_azs=var.private_subnet_azs
}
