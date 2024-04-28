
locals {
  cloud_watch_log_name = var.resource_name_prefix
}

resource "aws_cloudwatch_log_group" "log_groups" {
  name              = join("-", [local.cloud_watch_log_name, "selenium", var.service_type, "log-group"])
  retention_in_days = var.retention_in_days

  tags = {
    Name = join("-", [local.cloud_watch_log_name, "selenium", var.service_type, "log-group"])
  }
}

resource "aws_cloudwatch_log_stream" "log_streams" {
  name           = join("-", [local.cloud_watch_log_name, "selenium", var.service_type, "log-stream"])
  log_group_name = aws_cloudwatch_log_group.log_groups.name
}

# alarm

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = join("-", [var.resource_name_prefix, var.service_type, "utilization", "high"])
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.high_eval_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.period
  statistic           = var.statistic
  threshold           = var.high_threshold
  treat_missing_data  = var.treat_missing_data
  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }
  actions_enabled = true
  alarm_actions   = [var.alaram_scale_up_action_arn]
  tags = {
    Name = join("-", [var.resource_name_prefix, var.service_type, "utilization", "high"])
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = join("-", [var.resource_name_prefix, var.service_type, "utilization", "low"])
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.low_eval_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.period
  statistic           = var.statistic
  threshold           = var.low_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  actions_enabled = true
  alarm_actions   = [var.alaram_scale_down_action_arn]

  tags = {
    Name = join("-", [var.resource_name_prefix, var.service_type, "utilization", "low"])
  }
}
