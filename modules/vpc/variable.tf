variable "resource_name_prefix" {
  type        = string
  description = "A prefix used for naming resources."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets_cidr_list" {
  type        = list(string)
  description = "A list of CIDR blocks for public subnets."
}

variable "private_subnets_cidr_list" {
  type        = list(string)
  description = "A list of CIDR blocks for private subnets."
}
