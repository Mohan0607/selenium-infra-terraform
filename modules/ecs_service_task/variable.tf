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

# variable "image" {
#   type        = string
#   description = "The Docker image to use for the Selenium node container."
# }

# variable "container_name" {
#   type        = number
#   description = "Name of the Selenium node container."
# }
# variable "container_cpu" {
#   type        = number
#   description = "The number of CPU units to allocate for the Selenium node container."
# }

# variable "container_memory" {
#   type        = number
#   description = "The amount of memory (in MiB) to allocate for the Selenium node container."
# }

variable "node_environments" {
  type        = list(map(string))
  description = "A list of environment variables to pass to the Selenium node container."
  default     = []
}

# variable "container_port" {
#   type        = number
#   description = "The port on which the Selenium node container will listen."
# }
# variable "port_name" {
#   type        = number
#   description = "The port on which the Selenium node container will listen. eg hub-4444, hub-5555"
# }

# variable "cloudwatch_log_name" {
#   type        = string
#   description = "The name of the CloudWatch log group for the Selenium node."
# }
# variable "logs_stream_prefix" {
#   type        = string
#   description = "The name of the CloudWatch log stream prefix for the Selenium nodes."
# }

# variable "region" {
#   type        = string
#   description = "The AWS region where resources will be created."
# }

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