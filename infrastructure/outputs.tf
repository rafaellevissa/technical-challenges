output "cloudfront_url" {
  value = module.frontend.cloudfront_domain_name
}

output "eks_cluster_endpoint" {
  value = module.compute.cluster_endpoint
}

output "rds_endpoint" {
  value = module.database.db_instance_endpoint
}

output "cognito_pool_id" {
  value = module.auth.user_pool_id
}
