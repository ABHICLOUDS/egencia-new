variable "aws_region" {
type=string
}

#VPC Variables
variable "vpc_cidr_block" {
type=string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}


variable "appname" {
  type = string
}

variable "env" {
  type = string
}

#Ec2 Variables

variable "bucket_name" {
  type = string
}
variable "bucket_pl_script" {
  type = string
}

variable "sg_port" {
  type = list(number)
}

variable "pl_count" {
  type = number
}

variable "il_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "instance_profile_name" {
  type = string
}
variable "ebs_volume" {
  type = number
}

variable "ebs_volume_type" {
  type = string
}

#PL ALB Variable

variable "tg_port" {
  description = "The port on which targets receive traffic from the load balancer"
  type        = number
}

variable "tg_protocol" {
  description = "The protocol to use for routing traffic to targets"
  type        = string
}

variable "pl_hc_path" {
  description = "The destination for the health check request"
  type        = string
}

variable "pl_listener_port" {
  description = "The port on which the load balancer listens for incoming traffic"
  type        = number
}

variable "pl_listener_protocol" {
  description = "The protocol to use for the listener"
  type        = string
}

variable "pl_tg_attach_port" {
  description = "The port to use to connect with the target"
  type        = number
}

#IL ALB Variable
variable "il_hc_path" {
  description = "The destination for the health check request"
  type        = string
}

variable "il_listener_port" {
  description = "The port on which the load balancer listens for incoming traffic"
  type        = number
}

variable "il_listener_protocol" {
  description = "The protocol to use for the listener"
  type        = string
}

variable "il_tg_attach_port" {
  description = "The port to use to connect with the target"
  type        = number
}