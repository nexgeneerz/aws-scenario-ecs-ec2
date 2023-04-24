########################################################################################################################
## Creates an ASG linked with our main VPC
########################################################################################################################

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${var.namespace}_ASG_${var.environment}"
  max_size              = var.autoscaling_max_size
  min_size              = var.autoscaling_min_size
  vpc_zone_identifier   = aws_subnet.private.*.id
  health_check_type     = "EC2"
  protect_from_scale_in = true

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.namespace}_ASG_${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Scenario"
    propagate_at_launch = false
    value               = var.scenario
  }
}
