# ----------------------------------------
# 🌍 Terraform Configuration
# - Defines the backend storage for Terraform state
# - Specifies required Terraform and provider versions
# ----------------------------------------

terraform {
  # 🎯 Backend Configuration: Storing Terraform State in S3
  backend "s3" {
    bucket = "tm-devsecops-backend-codedevops" # 🔹 S3 bucket for storing state file
    key    = "secops-dev.tfstate"           # 🔹 Path to the state file in S3
    region = "ap-south-1"                   # 🔹 AWS region where the S3 bucket is located
  }

  # 🎯 Required Terraform Version & Providers
  required_version = ">= 0.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"  # 🔹 AWS provider for Terraform
      version = ">= 4.29.0"      # 🔹 Minimum required AWS provider version
    }
    random = {
      source  = "hashicorp/random"  # 🔹 Random provider (useful for generating random values)
      version = ">= 3.6.0"
    }
    template = {
      source  = "hashicorp/template"  # 🔹 Template provider (used for rendering templates)
      version = ">= 2.2.0"
    }
  }
}

# ----------------------------------------
# 🌍 AWS Provider Configuration
# - Configures Terraform to interact with AWS
# ----------------------------------------

provider "aws" {
  region              = var.region  # 🔹 AWS region, defined as a variable
  allowed_account_ids = ["739275478550"]  # 🔹 Restrict Terraform to this AWS account

  # ✅ Default tags applied to all AWS resources
  default_tags {
    tags = local.default_tags
  }
}

# ----------------------------------------
# 🏗 Kubernetes Provider Configuration
# - Connects Terraform with the EKS cluster
# ----------------------------------------

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint  # 🔹 EKS cluster API endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)  # 🔹 Decode CA certificate
  token                  = data.aws_eks_cluster_auth.eks.token  # 🔹 Authentication token for cluster access
}

# ----------------------------------------
# 🚀 Helm Provider Configuration
# - Allows Terraform to deploy Helm charts on Kubernetes
# ----------------------------------------

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint  # 🔹 Connect Helm to EKS API
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)  # 🔹 Decode CA certificate
    token                  = data.aws_eks_cluster_auth.eks.token  # 🔹 Authentication token
  }
}
