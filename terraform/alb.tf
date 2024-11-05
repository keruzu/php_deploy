
resource "aws_lb_target_group" "main" {
 name     = "main"
 port     = 80
 protocol = "HTTP"
 vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "hosts" {
 target_group_arn = aws_lb_target_group.main.arn
 target_id        = aws_instance.app.id
 port             = 80
}

resource "aws_lb" "main" {
 name               = "main"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.allow_tls.id]
 subnets            = [aws_subnet.public_subneta.id, aws_subnet.public_subnetb.id ]

 tags = {
   Environment = "dev"
 }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
