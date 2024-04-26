
resource "aws_appautoscaling_target" "target" {
  service_namespace = "ecs"
  #resource_id        = format("service/%s/%s", var.cluster_name, var.service_name)
  resource_id = "service/${var.cluster_name}/${var.service_name}"

  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity

}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = join("-", [var.resource_name_prefix, var.service_type, "scale", "up"])
  service_namespace  = aws_appautoscaling_target.target.service_namespace
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.scale_up_adjustment
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = join("-", [var.resource_name_prefix, var.service_type, "scale", "down"])
  service_namespace  = aws_appautoscaling_target.target.service_namespace
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.scale_down_adjustment
    }
  }
}
