variable "selenium_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "service_namespace_dns" {
  description = "The DNS namespace used for service discovery."
  type        = string
}

variable "resource_name_prefix" {
  type = string
}