variable "vpc_id" {
  type        = string
  description = "ID da VPC para o AWS Batch"
}

variable "private_subnets" {
  type        = list(string)
  description = "Subnets onde o Batch/Fargate vai rodar os jobs"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL da imagem Docker no ECR"
}
