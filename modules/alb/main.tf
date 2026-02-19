resource "aws_alb" "main" {
  name = "${var.environment}-${var.project}-${var.name_prefix}alb"
  internal = var.internal
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2 = true
  enable_cross_zone_load_balancing = true
  idle_timeout = 60

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-${var.name_prefix}alb"
    }
  )
}

resource "aws_alb_target_group" "main" {
  name = "${var.environment}-${var.project}-${var.name_prefix}tg"
  port = var.target_group_port
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/health"
    port = "traffic-port"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 3
    timeout = 5
    interval = 30
    matcher = "200-299"
  }

  deregistration_delay = 30
  stickiness {
    enabled = true
    type = "lb_cookie"
    cookie_duration = 86400
  }

  tags = merge(
    var.tags,
    {
        Name = "${var.environment}-${var.project}-frontend-tg"
    }
  )
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
  tags = var.tags
}