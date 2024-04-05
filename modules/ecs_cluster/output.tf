output "cluster_id" {
  value = aws_ecs_cluster.selenium_grid.id
}
output "cluster_name" {
  value = aws_ecs_cluster.selenium_grid.name
}
output "service_discovery_namespace_name" {
  value = aws_service_discovery_http_namespace.selenium.name
}

output "service_discovery_namespace_arn" {
  value = aws_service_discovery_http_namespace.selenium.arn
}

