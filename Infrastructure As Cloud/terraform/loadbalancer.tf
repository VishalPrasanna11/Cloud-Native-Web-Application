# Create Application Load Balancer
data "aws_acm_certificate" "ssl_certificate" {
  domain      = var.domain_name
  most_recent = true
  statuses    = ["ISSUED"]
}

resource "aws_lb" "web_app_lb" {
  name                             = "web-app-lb"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb_sg.id]              # Security group for the ALB
  subnets                          = [for s in aws_subnet.public_subnet : s.id] # Accessing all subnets in the VPC
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "web-app-lb"
  }
}

# Create Target Group for ALB to route traffic
resource "aws_lb_target_group" "web_app_target_group" {
  name     = "web-app-target-group"
  port     = 8080 # Port your app listens to
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    interval            = 30
    path                = "/healthz" # Health check endpoint for the app
    port                = "traffic-port"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200" # Health check status code
  }

  tags = {
    Name = "web-app-target-group"
  }
}

# Create Listener for ALB (HTTPS listener)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.ssl_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_target_group.arn
  }
}
