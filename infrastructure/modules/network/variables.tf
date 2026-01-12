variable "vpc_cidr" {
  type        = string
  description = "O bloco CIDR para a VPC"
}

variable "domain_name" {
  type        = string
  description = "O nome completo do domínio (ex: app.exemplo.com)"
}
