aws_region                 = "us-east-1"
env="qa"
appname="egencia"
tags                       = {
    env="QA-Egencia"
}
vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.4.0/24"]
public_subnet_azs          = ["us-east-1a", "us-east-1b"]
private_subnet_azs         = ["us-east-1a", "us-east-1b"]

bucket_name="demo-8795"
bucket_pl_script="script.sh"
sg_port=[80,8080,443,9090,22]
instance_type              = "t2.micro"
instance_profile_name      = "S3-fullacces-role"
ami_id          = "ami-0889a44b331db0194"
key_name        = "nv-key-ppk"
ebs_volume      = 10
ebs_volume_type = "gp2"
pl_count        = 2
il_count        = 2

pl_alb_name="pl-alb"
pl_tg_name="pl-tg"
pl_tg_port = "80"
pl_tg_protocol ="HTTP" 
pl_hc_path = "/egencia/index"
pl_listener_port="80"
pl_listener_protocol="HTTP"
pl_tg_attach_port="8080"

il_alb_name="il-alb"
il_tg_name="il-tg"
il_tg_port = "80"
il_tg_protocol ="HTTP" 
il_hc_path = "/"
il_listener_port="80"
il_listener_protocol="HTTP"
il_tg_attach_port="8080"
