variable "aws_region" {
  description = "Região da AWS"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "domain_name" {
  description = "Domínio principal do app"
  default     = "exemplo.com"
}

variable "db_password" {
  description = "Senha master do RDS (deve ser passada via env var ou secret)"
  sensitive   = true
}
