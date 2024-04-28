output "alaram_scale_down_action_arn" {
  value = aws_appautoscaling_policy.scale_down.arn
}

output "alaram_scale_up_action_arn" {
  value = aws_appautoscaling_policy.scale_up.arn
}