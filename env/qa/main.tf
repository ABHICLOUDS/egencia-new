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
  region = "us-east-1"
}

module "vpc" {
  source                    = "../../modules/vpc"
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnet_azs        = ["us-east-1a", "us-east-1b"]
  public_subnet_azs = ["us-east-1a", "us-east-1b"]
  appname                   = "demo-app"
  env                       = "qa"
  tags                      = {
    Environment = "Production"
  }
}

module "ec2" {
  source  = "../../modules/ec2"
  # Pass module-specific variables here
  appname          = "example-app"
  env              = "production"
  bucket_name      = "demo-8795"
  bucket_pl_script = "script.sh"
  sg_port          = [80, 443,8080]
  pl_count         = 2
  il_count         = 2
  instance_type    = "t2.micro"
  ami_id           = "ami-0889a44b331db0194"
  key_name         = "nv-key-ppk"
  instance_profile_name = "S3-fullacces-role"
  ebs_volume       = 10
  ebs_volume_type  = "gp2"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  tags                      = {
    Environment = "Production"
  }
}

module "pl_alb" {
  source  = "../../modules/alb"
  # Pass module-specific variables here
  alb_name               = "pl-example-alb"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [module.ec2.sg_id]
  subnets                = module.vpc.public_subnet_ids
  target_group_name      = "pl-example-target-group"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = "/egencia/index"
  listener_port          = 80
  listener_protocol      = "HTTP"
  target_count           = module.ec2.pl_count
  target_ids             = module.ec2.pl_instance_ids
  target_port            = 8080
}

# module "il_alb" {
#   source  = "../../modules/alb"
#   # Pass module-specific variables here
#   alb_name               = "il-example-alb"
#   internal               = true
#   load_balancer_type     = "application"
#   security_groups        = [module.vpc.security_group_id]
#   subnets                = module.vpc.private_subnet_ids
#   target_group_name      = "il-example-target-group"
#   target_group_port      = 80
#   target_group_protocol  = "HTTP"
#   vpc_id                 = module.vpc.vpc_id
#   health_check_path      = "/"
#   listener_port          = 80
#   listener_protocol      = "HTTP"
#   target_count           = module.ec2.il_count
#   target_ids             = module.ec2.il_instance_ids
#   target_port            = 8080
# }



