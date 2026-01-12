variable "vpc_id" {
  type        = string
  description = "ID da VPC onde o RDS será alocado"
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de subnets privadas para o DB Subnet Group"
}

variable "allowed_cidr_block" {
  type        = string
  description = "Bloco CIDR que terá acesso ao banco (geralmente o CIDR da VPC)"
}

variable "db_password" {
  type        = string
  description = "Senha master do banco de dados"
  sensitive   = true
}
