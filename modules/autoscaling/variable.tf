
variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster where the service is deployed."
}

variable "service_name" {
  type        = string
  description = "The name of the ECS service to apply the autoscaling configuration to."
}

variable "min_capacity" {
  type        = number
  description = "The minimum number of tasks that the autoscaling target should maintain."
}

variable "max_capacity" {
  type        = number
  description = "The maximum number of tasks that the autoscaling target can scale out to."
}

variable "resource_name_prefix" {
  type        = string
  description = "A prefix used for naming resources. Helps ensure uniqueness and easier identification."
}

variable "service_type" {
  type        = string
  description = "A descriptor for the type of service (e.g., 'chrome', 'firefox'). Used in naming and tagging."
}

variable "scale_up_adjustment" {
  type        = number
  description = "The number of tasks to add when scaling up. Positive integer for increasing capacity."
}

variable "scale_down_adjustment" {
  type        = number
  description = "The number of tasks to remove when scaling down. Negative integer for decreasing capacity."
}