
output "log_group_name" {
  value = aws_cloudwatch_log_group.log_groups.name
}

output "log_stream_name" {
  value = aws_cloudwatch_log_stream.log_streams.name
}
