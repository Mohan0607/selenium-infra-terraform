locals {
  cluster_name_prefix = join("-", [var.resource_name_prefix, var.selenium_cluster_name])
}
resource "aws_ecs_cluster" "selenium_grid" {
  name = local.cluster_name_prefix
  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.selenium.arn
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = local.cluster_name_prefix
  }
}

resource "aws_ecs_cluster_capacity_providers" "selenium_grid" {
  cluster_name       = aws_ecs_cluster.selenium_grid.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_service_discovery_http_namespace" "selenium" {
  name        = var.service_namespace_dns
  description = "Service Discovery for selenium"
}
