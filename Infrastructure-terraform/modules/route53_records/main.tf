resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = var.record.name
  type    = var.record.type

  dynamic "alias" {
    for_each = var.record.alias != null ? [var.record.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}
