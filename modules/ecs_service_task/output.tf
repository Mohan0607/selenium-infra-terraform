# output "service_arn" {
#   description = "The ARN of the ECS service."
#   value       = aws_ecs_service.selenium_node.arn
# }
output "service_name" {
  value = aws_ecs_service.selenium_node.name
}

# output "selenium_node_task_definition_arn" {
#   value = aws_ecs_task_definition.selenium_node.arn
# }
