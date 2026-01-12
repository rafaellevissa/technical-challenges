variable "domain_name" {
  type        = string
  description = "O nome do domínio (ex: app.exemplo.com)"
}

variable "zone_id" {
  type        = string
  description = "O ID da zona hospedada no Route53"
}

variable "env" {
  type    = string
  default = "prod"
}