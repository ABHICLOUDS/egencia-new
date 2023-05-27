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

# main.tf

module "vpc" {
  source  = "../../modules/vpc"
  # Pass module-specific variables here
  appname                   = "example-vpc"
  env                       = "production"
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  public_subnet_azs         = ["us-east-1a", "us-east-1b"]
  private_subnet_azs        = ["us-east-1a", "us-east-1b"]
  security_group_name       = "example-security-group"
  security_group_description = "Example security group"
   tags                  = {
  env = "QA-Egencia"
}
  security_group_ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "ec2" {
  source  = "../../modules/ec2"
  # Pass module-specific variables here
  appname          = "example-app"
  env              = "production"
  bucket_name      = "example-bucket"
  bucket_pl_script = "example-script.sh"
  sg_port          = [80, 443]
  pl_count         = 2
  il_count         = 2
  instance_type    = "t2.micro"
  ami_id           = "ami-12345678"
  key_name         = "example-key"
  instance_profile_name = "example-profile"
  ebs_volume       = 50
  ebs_volume_type  = "gp2"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  tags                  = {
  env = "QA-Egencia"
}
}

module "pl_alb" {
  source  = "../../modules/alb"
  # Pass module-specific variables here
  alb_name               = "pl-example-alb"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = [module.vpc.security_group_id]
  subnets                = module.vpc.public_subnet_ids
  target_group_name      = "pl-example-target-group"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = "/"
  listener_port          = 80
  listener_protocol      = "HTTP"
  target_count           = module.ec2.pl_count
  target_ids             = module.ec2.pl_instance_ids
  target_port            = 8080
}

module "il_alb" {
  source  = "../../modules/alb"
  # Pass module-specific variables here
  alb_name               = "il-example-alb"
  internal               = true
  load_balancer_type     = "application"
  security_groups        = [module.vpc.security_group_id]
  subnets                = module.vpc.private_subnet_ids
  target_group_name      = "il-example-target-group"
  target_group_port      = 80
  target_group_protocol  = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  health_check_path      = "/"
  listener_port          = 80
  listener_protocol      = "HTTP"
  target_count           = module.ec2.il_count
  target_ids             = module.ec2.il_instance_ids
  target_port            = 8080
}



