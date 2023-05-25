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

variable "tags" {
  type = map(string)
}


variable "appname" {
  type = string
}

variable "env" {
  type = string
}

variable "public_subnet_ids" {
  type    = list(string)
  
}

variable "private_subnet_ids" {
  type    = list(string)
  
}

variable "vpc_id" {
  type    = string
}


