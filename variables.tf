# ----------------------------------------
# 🌍 AWS Region Variable
# - Specifies the AWS region where resources will be deployed
# ----------------------------------------

variable "region" {
  type        = any  # Allows any data type (string, list, or map)
  default     = "ap-south-1"  # Default AWS region (Mumbai)
  description = "Value of the region where the resources will be created."
}

# ----------------------------------------
# 🌱 Environment Configuration Variable
# - Stores environment-specific configurations (e.g., dev, staging, prod)
# ----------------------------------------

variable "environments" {
  type        = any  # Allows flexibility for different types of configurations
  description = "The environment configuration."
}



