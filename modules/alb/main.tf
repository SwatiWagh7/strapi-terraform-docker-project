resource "aws_lb" "alb" {
  name               = "${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.environment}-tg"
  port        = var.strapi_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

 health_check {
  enabled             = true
  protocol            = "HTTP"
  port                = "traffic-port"
  path                = "/admin"
  matcher             = "200-399"
  interval            = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_instance
  port             = var.strapi_port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

