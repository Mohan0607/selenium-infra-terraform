# variables.tf in your module

variable "resource_name_prefix" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "selenium_hub_container_port" {
  type = number
}

variable "certificate_arn" {
  type = string
}

# variable "user_pool_arn" {
#   type = string
# }

# variable "user_pool_client_id" {
#   type = string
# }

# variable "user_pool_domain" {
#   type = string
# }
