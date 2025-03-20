environments = {
  default = {
    # ----------------------------------------
    # 🌍 Global Variables
    # - General configuration for the AWS environment
    # ----------------------------------------

    cluster_name                   = "codedevops-cluster"  # Name of the EKS cluster
    env                            = "default"  # Environment name (e.g., dev, staging, prod)
    region                         = "ap-south-1"  # AWS region for deployment
    vpc_id                         = "vpc-02af529e05c41b6bb"  # ID of the VPC where the cluster will be deployed
    vpc_cidr                       = "10.0.0.0/16"  # CIDR block of the VPC
    public_subnet_ids              = ["subnet-09aeb297a112767b2", "subnet-0e25e76fb4326ce99"]  # List of public subnet IDs
    cluster_version                = "1.29"  # Kubernetes version for EKS
    cluster_endpoint_public_access = true  # Allows public access to the EKS API server
    ecr_names                      = ["codedevops"]  # List of Elastic Container Registry (ECR) names

    # ----------------------------------------
    # 🚀 EKS Managed Node Groups Configuration
    # - Defines settings for worker nodes in the EKS cluster
    # ----------------------------------------

    eks_managed_node_groups = {
      generalworkload-v4 = {
        min_size       = 1  # Minimum number of worker nodes
        max_size       = 1  # Maximum number of worker nodes
        desired_size   = 1  # Desired number of worker nodes
        instance_types = ["m5a.xlarge"]  # EC2 instance type for worker nodes
        capacity_type  = "SPOT"  # Defines whether nodes are on-demand or spot instances
        disk_size      = 60  # Root volume size (in GB)
        ebs_optimized  = true  # Enables EBS-optimized instances for better performance

        # 🛡️ IAM Role Additional Policies for Nodes
        iam_role_additional_policies = {
          ssm_access        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"  # Allows access to AWS Systems Manager (SSM)
          cloudwatch_access = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"  # Allows logging and monitoring via CloudWatch
          service_role_ssm  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"  # Service role for EC2 instances with SSM access
          default_policy    = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"  # Default EC2 SSM policy
        }
      }
    }

    # ----------------------------------------
    # 🔐 Additional Security Group Rules
    # - Can be used to add custom security rules for the EKS cluster
    # ----------------------------------------

    cluster_security_group_additional_rules = {}

    # ----------------------------------------
    # 📊 EKS Cluster Logging Configuration
    # - Enables logging for different components of the EKS cluster
    # ----------------------------------------

    cluster_enabled_log_types = ["audit"]  # Specifies which log types are enabled (e.g., api, audit, authenticator)

    # ----------------------------------------
    # 🔑 EKS Access Entries
    # - Defines users who can access the EKS cluster with different roles
    # ----------------------------------------

    eks_access_entries = {
      viewer = {
        user_arn = []  # Users with read-only access (empty for now)
      }
      admin = {
        user_arn = ["arn:aws:iam::434605749312:root"]  # Users with admin access to EKS
      }
    }

    # ----------------------------------------
    # 🔄 EKS Add-ons Configuration
    # - Configures additional services like CoreDNS
    # ----------------------------------------

    coredns_config = {
      replicaCount = 1  # Number of replicas for CoreDNS
    }
  }
}
