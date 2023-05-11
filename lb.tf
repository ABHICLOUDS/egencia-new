resource "aws_lb" "example_lb" {
  name               = "${var.tags}-example-lb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.example_sg1.id]
  subnets            = aws_subnet.public_subnets.*.id

  tags = {
    Name = "${var.tags}-pl-alb"
  }
}

resource "aws_lb_target_group" "example_target_group" {
  name     = "${var.tags}-example-target-group"
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.example_vpc.id

  tags = {
    Name = "${var.tags}-example-target-group"
  }
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_lb.arn
  port              = var.listner_port
  protocol          = var.listner_protocol

  default_action {
    target_group_arn = aws_lb_target_group.example_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "example_target_group_attachment" {
  count          = var.pl_count
  target_group_arn = aws_lb_target_group.example_target_group.arn
  target_id        = aws_instance.example_instances[count.index].id
  port             = var.tg_attach_port
}
