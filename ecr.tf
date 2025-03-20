# Create multiple ECR repositories dynamically using a loop
resource "aws_ecr_repository" "ecr_repos" {
  for_each = toset(local.ecr_names)  # Iterate over the set of repository names

  name                 = each.key    # Assign each repository name dynamically
  image_tag_mutability = "MUTABLE"   # Allow image tags to be overwritten

  # Adding tags for resource management
  tags = {
    Name = "${local.project}-${local.env}-ecr-${each.key}"
  }
}
