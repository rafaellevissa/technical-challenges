resource "aws_ecr_repository" "app_repo" {
  name                 = "backend-app"
  image_tag_mutability = "IMMUTABLE"
}
