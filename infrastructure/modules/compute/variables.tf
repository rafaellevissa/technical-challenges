variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o cluster EKS será implantado"
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de IDs das subnets privadas para os nós do EKS"
}

variable "waf_acl_arn" {
  type        = string
  description = "ARN do WAF para associar ao Load Balancer"
  default     = "" 
}