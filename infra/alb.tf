########################################################################################################################
## Application Load Balancer in public subnets with HTTP default listener that redirects traffic to HTTPS
########################################################################################################################

resource "aws_alb" "alb" {
  name            = "${var.namespace}-ALB-${var.environment}"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public.*.id

  tags = {
    Scenario = var.scenario
  }
}

########################################################################################################################
## Default HTTPS listener that blocks all traffic without valid custom origin header
########################################################################################################################

resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.alb_certificate.arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access denied"
      status_code  = "403"
    }
  }

  tags = {
    Scenario = var.scenario
  }

  depends_on = [aws_acm_certificate.alb_certificate]
}

########################################################################################################################
## HTTPS Listener Rule to only allow traffic with a valid custom origin header coming from CloudFront
########################################################################################################################

resource "aws_alb_listener_rule" "https_listener_rule" {
  listener_arn = aws_alb_listener.alb_default_listener_https.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = ["${var.environment}.${var.domain_name}"]
    }
  }

  condition {
    http_header {
      http_header_name = "X-Custom-Header"
      values           = [var.custom_origin_host_header]
    }
  }

  tags = {
    Scenario = var.scenario
  }
}

########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.namespace}-TargetGroup-${var.environment}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.default.id
  deregistration_delay = 5

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = var.healthcheck_matcher
    path                = var.healthcheck_endpoint
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30
  }

  tags = {
    Scenario = var.scenario
  }

  depends_on = [aws_alb.alb]
}
