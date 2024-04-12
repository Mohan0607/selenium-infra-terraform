# output "ecs_task_execution_role_arn" {
#   description = "The ARN of the ECS task execution role"
#   value       = aws_iam_role.ecs_task_execution_role.arn
# }

output "iam_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.main.arn
}

output "iam_policy_arn" {
  description = "The ARN of the IAM policy."
  value       = aws_iam_policy.main.arn
}
