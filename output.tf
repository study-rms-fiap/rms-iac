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