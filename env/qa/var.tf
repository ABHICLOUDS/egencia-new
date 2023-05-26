# # variables.tf

# variable "aws_region" {
#   description = "AWS region"
#   default     = "us-west-2"
# }

# variable "appname" {
#   description = "Application name"
# }

# variable "env" {
#   description = "Environment"
# }

# variable "tags" {
#   description = "Tags for resources"
#   type        = map(string)
# }

# variable "vpc_cidr_block" {
#   description = "CIDR block for VPC"
# }

# variable "public_subnet_cidr_blocks" {
#   description = "CIDR blocks for public subnets"
#   type        = list(string)
# }

# variable "public_subnet_azs" {
#   description = "Availability zones for public subnets"
#   type        = list(string)
# }

# variable "private_subnet_cidr_blocks" {
#   description = "CIDR blocks for private subnets"
#   type        = list(string)
# }

# variable "private_subnet_azs" {
#   description = "Availability zones for private subnets"
#   type        = list(string)
# }

# # Define other variables

# variable "bucket_name" {
#   description = "Bucket name for scripts"
# }

# variable "bucket_pl_script" {
#   description = "Path to PL script in bucket"
# }

# variable "pl_count" {
#   description = "Count of PL instances"
#   type        = number
# }

# variable "il_count" {
#   description = "Count of IL instances"
#   type        = number
# }

# variable "ami_id" {
#   description = "AMI ID"
# }

# variable "instance_type" {
#   description = "EC2 instance type"
# }

# variable "key_name" {
#   description = "Key pair name"
# }

# variable "ebs_volume" {
#   description = "EBS volume size (in GB)"
#   type        = number
# }

# variable "ebs_volume_type" {
#   description = "EBS volume type"
# }

# variable "instance_profile_name" {
#   description = "Instance profile name"
# }

# variable "sg_port" {
#   description = "Security group port"
#   type        = number
# }

# variable "pl_hc_path" {
#   description = "Path for PL health check"
# }

# variable "pl_listener_port" {
#   description = "Port for PL listener"
#   type        = number
# }

# variable "pl_listener_protocol" {
#   description = "Protocol for PL listener"
# }

# variable "pl_tg_attach_port" {
#   description = "Port for attaching targets to PL target group"
#   type        = number
# }

# variable "il_hc_path" {
#   description = "Path for IL health check"
# }

# variable "il_listener_port" {
#   description = "Port for IL listener"
#   type        = number
# }

# variable "il_listener_protocol" {
#   description = "Protocol for IL listener"
# }

# variable "il_tg_attach_port" {
#   description = "Port for attaching targets to IL target group"
#   type        = number
# }

# # Define other variables
