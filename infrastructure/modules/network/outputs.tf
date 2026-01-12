output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID da VPC criada"
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "Lista de IDs das subnets privadas"
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "Bloco CIDR da VPC"
}

output "hosted_zone_id" {
  value       = aws_route53_zone.main.zone_id
  description = "ID da Zona de DNS para ser usada por outros módulos"
}

output "hosted_zone_name" {
  value = aws_route53_zone.main.name
}
