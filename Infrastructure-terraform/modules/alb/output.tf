output "target_group_arn" {
  value = aws_alb_target_group.selenium.arn
}
output "alb_dns_domain" {
  value = aws_alb.selenium.dns_name
}
output "alb_zone_id" {
  value = aws_alb.selenium.zone_id
}