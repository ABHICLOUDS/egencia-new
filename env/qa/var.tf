# variables.tf

variable "aws_region" {}

variable "appname" {}

variable "env" {}

variable "tags" {}

variable "vpc_cidr_block" {}

variable "public_subnet_cidr_blocks" {}

variable "public_subnet_azs" {}

variable "private_subnet_cidr_blocks" {}

variable "private_subnet_azs" {}

# Define other variables

variable "bucket_name" {}

variable "bucket_pl_script" {}

variable "pl_count" {}

variable "il_count" {}

variable "ami_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "ebs_volume" {}

variable "ebs_volume_type" {}

variable "instance_profile_name" {}

variable "sg_port" {}

variable "pl_alb_name" {}

variable "pl_tg_name" {}

variable "pl_tg_port" {}

variable "pl_tg_protocol" {}

variable "pl_hc_path" {}

variable "pl_listener_port" {}

variable "pl_listener_protocol" {}

variable "pl_tg_attach_port" {}

variable "il_alb_name" {}

variable "il_tg_name" {}

variable "il_tg_port" {}

variable "il_tg_protocol" {}

variable "il_hc_path" {}

variable "il_listener_port" {}

variable "il_listener_protocol" {}

variable "il_tg_attach_port" {}

# Define other variables
