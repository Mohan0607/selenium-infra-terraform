variable "resource_name_prefix" {
  type = string
}

variable "execution_role_arn" {
  type        = string
  description = "The ARN of the role that the ECS task execution should assume."
}

variable "task_role_arn" {
  type        = string
  description = "The ARN of the IAM role that allows your ECS task to make calls to other AWS services."
}

variable "task_cpu" {
  type        = string
  description = "The amount of CPU to allocate for the Selenium node task."
}

variable "task_memory" {
  type        = string
  description = "The amount of memory (in MiB) to allocate for the Selenium node task."
}
variable "node_environments" {
  type        = list(map(string))
  description = "A list of environment variables to pass to the Selenium node container."
  default     = []
}
variable "cluster_id" {
  type        = string
  description = "The ID of the ECS cluster where the Selenium node service will be deployed."
}

variable "desired_count" {
  type        = number
  description = "The number of instances of the task definition to place and keep running."
}

variable "service_name" {
  type        = string
  description = "Prefix for the service name."
}

variable "service_discovery_arn" {
  type        = string
  default     = ""
  description = "The ARN for the service discovery (optional)."
}
variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs to associate with the ECS Service."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ECS Service."
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public IP. Set true for public subnets."
  default     = false
}
variable "service_connect_config" {
  description = "Configuration for service connectivity"
  type = list(object({
    namespace = string
    enabled   = bool
    service = optional(list(object({
      client_alias = object({
        port     = number
        dns_name = string
      })
      port_name      = string
      discovery_name = string
    })))
  }))
}

variable "load_balancer_configuration" {
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  description = "Load balance Configuration for target group."
  default     = []
}

variable "containers" {
  description = "A list of container definitions"
  type = list(object({
    name         = string
    image        = string
    cpu          = number
    memory       = number
    environments = list(map(string))
    command      = list(string)
    ports = list(object({
      containerPort = number
      hostPort      = number
      protocol      = string
    }))
    logs = list(object({
      logs_stream_prefix = string
      region             = string
      loggroup_name      = string
    }))
  }))
}
variable "service_type" {
  type        = string
  description = "A descriptor for the type of service (e.g., 'chrome', 'firefox'). Used in naming and tagging."
}