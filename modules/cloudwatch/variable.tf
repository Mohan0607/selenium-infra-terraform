

variable "resource_name_prefix" {
  type        = string
  description = "A prefix used for naming resources. Helps ensure uniqueness and easier identification."
}

variable "name_suffix" {
  type        = string
  description = "A suffix for the logs used for naming resources. Helps ensure uniqueness and easier identification."
}
variable "retention_in_days" {
  type        = string
  description = "Number of days for retention"
}

# alarm
variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster where the service is deployed."
}

variable "service_name" {
  type        = string
  description = "The name of the ECS service to apply the autoscaling configuration to."
}
variable "service_type" {
  type        = string
  description = "A descriptor for the type of service (e.g., 'chrome', 'firefox'). Used in naming and tagging."
}
variable "high_threshold" {
  type        = string
  description = "The CPU utilization percentage that triggers the high CPU utilization alarm."
}

variable "low_threshold" {
  type        = string
  description = "The CPU utilization percentage that triggers the low CPU utilization alarm."
}
variable "high_eval_periods" {
  type        = string
  description = "The number of evaluation periods for the high CPU utilization alarm."
}

variable "low_eval_periods" {
  type        = string
  description = "The number of evaluation periods for the low CPU utilization alarm."
}

variable "period" {
  type        = string
  description = "The period, in seconds, over which the specified statistic is applied."
}

variable "alaram_scale_up_action_arn" {
  type        = string
  description = "The arn for auto scalling Up policy"
}

variable "alaram_scale_down_action_arn" {
  type        = string
  description = "The arn for auto scalling down policy"
}

variable "statistic" {
  type        = string
  description = "The statistic for the CloudWatch alarm, such as 'Average', 'Minimum', 'Maximum', 'Sum', or 'SampleCount'."
}

variable "treat_missing_data" {
  type        = string
  description = "The action to take when data is missing during evaluation of the CloudWatch alarm. Possible values are 'missing', 'ignore', 'breaching', or 'notBreaching'."
}

