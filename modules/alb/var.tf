variable "alb_name" {
  type        = string
}

variable "internal" {
  type        = bool
}

variable "load_balancer_type" {
  type        = string
}

variable "security_groups" {
  type        = list(string)
}

variable "subnets" {
  type        = list(string)
}

variable "target_group_name" {
  type        = string
}

variable "target_group_port" {
  type        = number
}

variable "target_group_protocol" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "health_check_path" {
  type        = string
}

variable "listener_port" {
  type        = number
}

variable "listener_protocol" {
  type        = string
}

variable "target_count" {
  type        = number
}

variable "target_ids" {
  type        = list(string)
}

variable "target_port" {
  type        = number
}