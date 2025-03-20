# ------------------------------
# EKS Cluster Outputs
# ------------------------------

# Output the name of the created EKS cluster
output "cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the created EKS cluster."
}

# Output the version of Kubernetes running on the EKS cluster
output "cluster_version" {
  value       = module.eks.cluster_version
  description = "The version of Kubernetes running on the EKS cluster."
}

# Output the Kubernetes API server endpoint for the EKS cluster
output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint for the EKS Kubernetes API server."
}

# ------------------------------
# Access & Authentication Outputs
# ------------------------------

# Output the list of IAM access entries for users interacting with the EKS cluster
output "access_entries" {
  value       = module.eks.access_entries
  description = "IAM access entries for the EKS cluster, defining which users or roles have permissions."
}

# Output the OIDC provider URL for EKS authentication
output "oidc_provider" {
  value       = module.eks.oidc_provider
  description = "The OpenID Connect (OIDC) provider URL for authentication in EKS."
}

# Output the OIDC provider ARN for IAM role authentication
output "oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "The ARN of the OpenID Connect (OIDC) provider associated with the EKS cluster."
}

# ------------------------------
# ACM Certificate Outputs
# ------------------------------

# Output the ARN of the ACM certificate used for securing EKS Ingress (TLS/SSL)
output "acm_certificate_arn" {
  value       = module.acm_certificate.acm_certificate_arn
  description = "The ARN of the ACM certificate used for securing the cluster with HTTPS/TLS."
}
