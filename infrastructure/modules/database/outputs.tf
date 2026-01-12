output "db_instance_endpoint" {
  value       = aws_db_instance.mysql.endpoint
  description = "O endpoint de conexão do banco de dados MySQL"
}
