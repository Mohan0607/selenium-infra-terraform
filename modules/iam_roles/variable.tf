variable "resource_name_prefix" {
  type        = string
  description = "Prefix for the resource names"
}

variable "policy_description" {
  type        = string
  description = "Description for the IAM policy"
  default     = "Allows ECS containers to execute commands on our behalf"
}
