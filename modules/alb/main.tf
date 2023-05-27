# main.tf (inside ALB module)

resource "aws_lb" "example_lb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_lb_target_group" "example_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path = var.health_check_path
  }

  tags = {
    Name = var.target_group_name
  }
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.example_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "example_target_group_attachment" {
  count            = var.target_count
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = var.target_ids[count.index]
  port             = var.target_port
}
