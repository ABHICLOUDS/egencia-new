variable "vpc_cidr_block" {
type=string
}

variable "aws_region" {
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