variable "local_aws_profile_name" {
  type        = string
  description = "AWS Profile name used in local machine"
}

# Project Configurations and Name Conventions
variable "region" {
  type        = string
  description = "Project Region"
  default     = "us-west-1"
}
variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}
variable "resource_name_prefix" {
  type        = string
  description = "Resource name prefix"
}

variable "project_resource_administrator" {
  type        = string
  description = "Project Resource Administrator"
  default     = "Mohan Durai"
}
variable "project_name" {
  type        = string
  description = "Project name"
}
variable "project_environment" {
  type        = string
  description = "Project Environment"
}

# Network Related VPC, Subnets and Security Groups
variable "vpc_cidr_block" {
  type        = string
  description = "The cicdr of a VPC in your AWS account"
}

variable "public_subnets_cidr_list" {
  type        = list(string)
  description = "The cicdr of the public subnet, for the load balancer"
}

variable "private_subnets_cidr_list" {
  type        = list(string)
  description = "The cicdr of the private subnet, for the containers"
}


# DNS
variable "load_balancer_domain_name" {
  type        = string
  description = "Load Balancer Domain name"
}
variable "acm_cert_arn" {
  type        = string
  description = "ARN of the aws certificate manager used for the ALB"
}
variable "cf_aliases" {
  type        = list(string)
  description = "List of aliases used for the portal UI"
}

# ECS cluster
variable "service_discovery_namespace_name" {
  description = "The DNS namespace used for service discovery."
  type        = string
}
# ECS Chrome task defintions
variable "selenium_chrome_service_desired_count" {
  type        = string
  description = "Number of instances for Chrome Node"
}
variable "selenium_chrome_image" {
  type        = string
  description = "Image Url for Chrome Node image"
}
variable "selenium_chrome_task_memory" {
  type        = number
  description = "The memory allocated to the Chrome Node task "
}

variable "selenium_chrome_container_cpu" {
  type        = number
  description = "The CPU units allocated to the Chrome Node container."
}

variable "selenium_chrome_container_memory" {
  type        = number
  description = "The memory allocated to the Chrome Node container "
}

variable "selenium_chrome_task_cpu" {
  type        = number
  description = "The CPU units allocated to the Chrome Node task."
}

# ECS Hub task defintions
variable "selenium_hub_service_desired_count" {
  type        = string
  description = "Number of instances for hub Node"
}
variable "selenium_hub_image" {
  type        = string
  description = "Image Url for hub Node image"
}

variable "selenium_hub_container_cpu" {
  type        = number
  description = "The CPU units allocated to the hub Node container."
}

variable "selenium_hub_container_memory" {
  type        = number
  description = "The memory allocated to the hub Node container"
}
variable "selenium_hub_task_cpu" {
  type        = number
  description = "The CPU units allocated to the hub Node task."
}
variable "selenium_hub_task_memory" {
  type        = number
  description = "The memory allocated to the hub Node task"
}
variable "selenium_hub_container_port" {
  type        = number
  description = "The selenium hub container port"
}
# OIDC workspace

variable "github_org_name" {
  description = "Name of ORG name"
  type        = string
}
variable "github_repo_name" {
  description = "Name of repository."
  type        = string
}

variable "github_branch_name" {
  description = "Name of the Branch"
  type        = string
}