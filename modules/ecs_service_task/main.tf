locals {
  service_name_prefix = join("-", [var.resource_name_prefix, var.service_name])
}

resource "aws_ecs_task_definition" "selenium_node" {
  family                   = "selenium-node-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = jsonencode([for container in var.containers : {
    name        = container.name
    image       = container.image
    cpu         = container.cpu
    memory      = container.memory
    essential   = true
    environment = container.environments
    portMappings = [for port in container.ports : {
      name          = join("-", [container.name, port.protocol, port.hostPort])
      containerPort = port.containerPort
      hostPort      = port.hostPort
      protocol      = port.protocol
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = container.logs[0].loggroup_name
        "awslogs-region"        = container.logs[0].region
        "awslogs-stream-prefix" = container.logs[0].logs_stream_prefix
      }
    }
  }])

}

resource "aws_ecs_service" "selenium_node" {
  name            = local.service_name_prefix
  cluster         = var.cluster_id
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.selenium_node.arn

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnet_ids
    assign_public_ip = var.assign_public_ip
  }

  dynamic "service_connect_configuration" {
    for_each = length(var.service_connect_config) > 0 ? var.service_connect_config : []
    content {
      namespace = service_connect_configuration.value.namespace
      enabled   = service_connect_configuration.value.enabled

      dynamic "service" {
        for_each = can(length(try(service_connect_configuration.value.service, []))) ? service_connect_configuration.value.service : []
        content {
          client_alias {
            port     = service.value.client_alias.port
            dns_name = service.value.client_alias.dns_name
          }
          port_name      = service.value.port_name
          discovery_name = service.value.discovery_name
        }
      }
    }
  }
  dynamic "load_balancer" {
    for_each = var.load_balancer_configuration
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }

  }
  tags = {
    Name = local.service_name_prefix
  }

  depends_on = [aws_ecs_task_definition.selenium_node]
}
