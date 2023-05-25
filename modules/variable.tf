

variable "aws_region" {}


variable "tags" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

variable "listner_port" {
  type = number
}

variable "listner_protocol" {
  type = string
}

variable "tg_attach_port" {
  type = number
}

variable "hc_path" {
  type = string
}


