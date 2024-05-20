output "repository_url_order" {
  description = "The URL of the repository"
  value       = module.ecr-order.repository_url
}

output "repository_url_payment" {
  description = "The URL of the repository"
  value       = module.ecr-payment.repository_url
}

output "repository_url_production" {
  description = "The URL of the repository"
  value       = module.ecr-production.repository_url
}


###########################################################################
#EKS

output "cluster_endpoint" {
  description = "Endpoint Cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids"
  value       = module.eks.cluster_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "hello_base_url" {
  value = module.gateway.hello_base_url
}

###########################################################################
#Database

output "rds_order_endpoint" {
  value = module.database.rds_order_endpoint
}