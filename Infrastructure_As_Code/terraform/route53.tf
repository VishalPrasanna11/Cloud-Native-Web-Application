# Get the hosted zone details for the domain
data "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Route 53 A Record for dev subdomain (pointing to the Load Balancer)
resource "aws_route53_record" "subdomain_a_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name # Points to dev subdomain
  type    = "A"

  # Alias pointing to the ALB
  alias {
    name                   = aws_lb.web_app_lb.dns_name
    zone_id                = aws_lb.web_app_lb.zone_id
    evaluate_target_health = true
  }
}

# Route 53 A Record for demo subdomain (pointing to the Load Balancer)


# Output for the full domain of dev subdomain
output "subdomain_fqdn" {
  value = aws_route53_record.subdomain_a_record.fqdn
}

# Output for the full domain of demo subdomain


# Output for the Route 53 Zone ID
output "route53_zone_id" {
  value = data.aws_route53_zone.primary.zone_id
}
