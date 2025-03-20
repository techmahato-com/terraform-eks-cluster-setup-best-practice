# ------------------------------
# AWS EKS Cluster Module
# ------------------------------
module "eks" {
  source      = "terraform-aws-modules/eks/aws"
  version     = "20.13.1"

  # Cluster Configuration
  cluster_name                           = local.cluster_name
  cluster_version                        = local.cluster_version
  cluster_enabled_log_types              = local.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = 30  # Retain logs for 30 days
  cluster_endpoint_public_access         = true  # Allow public access to the API server

  # Cluster Add-ons (CNI, CoreDNS, Kube-Proxy)
  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values        = jsonencode(local.coredns_config)
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.vpc_cni.arn
    }
  }

  # VPC & Networking Configuration
  vpc_id     = local.vpc_id
  subnet_ids = local.public_subnet_ids

  # Managed Node Groups (Worker Nodes)
  eks_managed_node_group_defaults = {
    # This is a placeholder and will not affect actual deployment
  }
  eks_managed_node_groups = local.eks_managed_node_groups

  # Security Groups
  cluster_security_group_additional_rules = local.cluster_security_group_additional_rules

  # RBAC Permissions for Cluster Admins
  enable_cluster_creator_admin_permissions = false

  # IAM Access Configuration for EKS Users
  access_entries = {
    for user in local.eks_access_entries : user.username => {
      kubernetes_groups = []
      principal_arn     = user.username
      policy_associations = {
        single = {
          policy_arn = user.access_policy
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # Tags for Resource Management
  tags = local.default_tags
}

# ------------------------------
# IAM Role for VPC CNI Add-on
# ------------------------------
resource "aws_iam_role" "vpc_cni" {
  name               = "${local.prefix}-vpc-cni"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${module.eks.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${module.eks.oidc_provider}:sub": "system:serviceaccount:kube-system:aws-node"
        }
      }
    }
  ]
}
EOF
}

# Attach EKS CNI Policy to IAM Role
resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
