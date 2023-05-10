variable "vpc_cidr_block" {}

variable "aws_region" {}

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

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "tags" {
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

variable "pl_count" {
  type = number
}

variable "il_count" {
  type = number
}
