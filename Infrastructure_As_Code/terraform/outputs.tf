output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "application_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.application_sg.id
}

# output "web_app_instance_id" {
#   description = "The ID of the web application EC2 instance"
#   value       = aws_instance.web_app_instance.id
# }

# Output for Load Balancer's DNS Name (for public access)
output "web_app_lb_dns_name" {
  description = "The DNS name of the web application Load Balancer"
  value       = aws_lb.web_app_lb.dns_name
}

# Output for Private IPs of EC2 instances in Auto Scaling Group (requires use of data sources or instances)
# output "web_app_instance_private_ips" {
#   description = "The private IP addresses of EC2 instances in the Auto Scaling group"
#   value       = aws_autoscaling_group.web_app_asg.instances[*].private_ip
# }
