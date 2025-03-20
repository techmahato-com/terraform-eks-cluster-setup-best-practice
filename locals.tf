# ----------------------------------------
# 🔑 AWS EKS Cluster Authentication
# - Retrieves authentication token for connecting to the EKS cluster
# ----------------------------------------

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name  # EKS cluster name retrieved from the module
}

# ----------------------------------------
# 🏗 Local Variables
# - Stores commonly used values derived from environment variables
# ----------------------------------------

locals {
  # 🌍 Environment Configuration
  environment = terraform.workspace  # Gets the current Terraform workspace (default, dev, prod, etc.)

  # 🔍 Fetching Environment-Specific Configuration from `var.environments`
  k8s_info = lookup(var.environments, local.environment)  # Retrieves configuration for the current environment

  # 🚀 Core EKS Cluster Settings
  cluster_name                            = lookup(local.k8s_info, "cluster_name")  # Name of the EKS cluster
  region                                  = lookup(local.k8s_info, "region")  # AWS region
  env                                     = lookup(local.k8s_info, "env")  # Environment name
  vpc_id                                  = lookup(local.k8s_info, "vpc_id")  # VPC ID
  vpc_cidr                                = lookup(local.k8s_info, "vpc_cidr")  # CIDR block of the VPC
  public_subnet_ids                       = lookup(local.k8s_info, "public_subnet_ids")  # List of public subnet IDs
  cluster_version                         = lookup(local.k8s_info, "cluster_version")  # Kubernetes version
  cluster_enabled_log_types               = lookup(local.k8s_info, "cluster_enabled_log_types")  # Enabled log types
  eks_managed_node_groups                 = lookup(local.k8s_info, "eks_managed_node_groups")  # EKS node group configurations
  cluster_security_group_additional_rules = lookup(local.k8s_info, "cluster_security_group_additional_rules")  # Custom security rules
  coredns_config                          = lookup(local.k8s_info, "coredns_config")  # Configuration for CoreDNS
  ecr_names                               = lookup(local.k8s_info, "ecr_names")  # List of ECR repositories

  # 🔹 Prefix for Naming Resources
  prefix = "${local.project}-${local.environment}-${var.region}"
  
  # 🔑 EKS Access Entries
  # - Creates a flattened list of users with access to the EKS cluster
  eks_access_entries = flatten([
    for k, v in local.k8s_info.eks_access_entries : [
      for s in v.user_arn : {
        username     = s
        access_policy = lookup(local.eks_access_policy, k)  # Lookup policy based on role (admin/viewer)
        group        = k
      }
    ]
  ])

  # 📜 EKS Access Policies for IAM Roles
  eks_access_policy = {
    viewer = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"  # View-only policy
    admin  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"  # Admin policy
  }

  # 📌 Project Name & AWS Account ID
  project    = "codedevops"  # Name of the project
  account_id = data.aws_caller_identity.current.account_id  # AWS Account ID

  # 🏷️ Default Tags Applied to Resources
  default_tags = {
    environment = local.environment
    managed_by  = "terraform"
    project     = local.project
  }
}
