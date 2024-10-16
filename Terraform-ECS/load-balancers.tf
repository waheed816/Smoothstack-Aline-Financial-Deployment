resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb-mm"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false

  tags = {
    Name = "ecs-alb-mm"
  }

  depends_on = [aws_subnet.public1, aws_subnet.public2, aws_security_group.alb_sg]
}

################################## Listeners ####################################

resource "aws_lb_listener" "user" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8070
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user.arn
  }

  depends_on = [aws_lb.ecs_alb, aws_lb_target_group.user]
}

resource "aws_lb_listener" "underwriter" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8071
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.underwriter.arn
  }

  depends_on = [aws_lb.ecs_alb, aws_lb_target_group.underwriter]
}

resource "aws_lb_listener" "account" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8072
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.account.arn
  }

  depends_on = [aws_lb.ecs_alb, aws_lb_target_group.account]
}

resource "aws_lb_listener" "transaction" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8073
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.transaction.arn
  }

  depends_on = [aws_lb.ecs_alb, aws_lb_target_group.transaction]
}

resource "aws_lb_listener" "bank" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 8083
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bank.arn
  }

  depends_on = [aws_lb.ecs_alb, aws_lb_target_group.bank]
}

################################## Target Groups ####################################

resource "aws_lb_target_group" "user" {
  name     = "tg-user-mm"
  port     = 8070
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path                = "/health"
    }

  depends_on = [aws_vpc.main]

}

resource "aws_lb_target_group" "underwriter" {
  name     = "tg-underwriter-mm"
  port     = 8071
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/health"
    }

  depends_on = [aws_vpc.main]
}

resource "aws_lb_target_group" "account" {
  name     = "tg-account-mm"
  port     = 8072
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path   = "/health"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_lb_target_group" "transaction" {
  name     = "tg-transaction-mm"
  port     = 8073
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path   = "/health"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_lb_target_group" "bank" {
  name     = "tg-bank-mm"
  port     = 8083
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path   = "/health"
  }

  depends_on = [aws_vpc.main]
}



# resource "aws_lb" "admin_portal_lb" {
#   name               = "admin-portal-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.admin_portal_sg.id]
#   subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
# }

# resource "aws_lb_target_group" "admin_portal_target_group" {
#   name     = "admin-portal-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200-299"
#   }
# }

# resource "aws_lb_listener" "admin_portal_listener" {
#   load_balancer_arn = aws_lb.admin_portal_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.admin_portal_target_group.arn
#   }
# }

# resource "aws_lb" "aline_gateway_lb" {
#   name               = "aline-gateway-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.aline_gateway_sg.id]
#   subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
# }

# resource "aws_lb_target_group" "aline_gateway_target_group" {
#   name     = "aline-gateway-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     path                = "/"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     matcher             = "200-299"
#   }
# }

# resource "aws_lb_listener" "aline_gateway_listener" {
#   load_balancer_arn = aws_lb.aline_gateway_lb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.aline_gateway_target_group.arn
#   }
# }
