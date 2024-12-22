resource "aws_security_group" "application_sg" {
  name        = "application-security-group"
  description = "Security group for web applications"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow SSH access (port 22) only for management/administration
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Restrict traffic to ALB security group
  }

  # Allow traffic on port 8080 ONLY from the load balancer's security group
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id] # Load balancer security group
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "load-balancer-security-group"
  description = "Security group for Load Balancer"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow HTTP and HTTPS traffic from anywhere
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
