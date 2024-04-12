resource "aws_alb" "selenium" {
  name            = join("-", [var.resource_name_prefix, "selenium", "grid", "alb"])
  subnets         = var.public_subnet_ids
  security_groups = var.security_group_ids
}

resource "aws_alb_target_group" "selenium" {
  name        = join("-", [var.resource_name_prefix, "hub", "tg"])
  port        = var.selenium_hub_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 5
    interval            = 180
    protocol            = "HTTP"
    port                = "4444"
    matcher             = "200"
    timeout             = 5
    path                = "/ui"
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.selenium.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.selenium.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.selenium.arn
  }
}
