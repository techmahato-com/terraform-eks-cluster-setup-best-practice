# Data source to fetch Route 53 Zone ID for the given domain
data "aws_route53_zone" "selected_zone" {
  name = "techmahato.com."  # The trailing dot ensures it's a fully qualified domain name
}

# ACM (AWS Certificate Manager) module to request an SSL/TLS certificate
module "acm_certificate" {
  source      = "terraform-aws-modules/acm/aws"
  version     = "4.0.1"

  # Primary domain for the certificate
  domain_name = "techmahato.com"

  # Additional domain names covered by the certificate (wildcard for subdomains)
  subject_alternative_names = [
    "*.techmahato.com"
  ]

  # Associating the certificate with the Route 53 hosted zone
  zone_id = data.aws_route53_zone.selected_zone.id

  # Using DNS validation for certificate approval
  validation_method   = "DNS"
  wait_for_validation = true  # Ensures Terraform waits for validation completion

  # Tagging for resource organization
  tags = {
    Name = "${local.project}-${local.env}-acm-certificate"
  }
}
