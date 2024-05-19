output "repository_url" {
  description = "he URL of the repository"
  value       = module.ecr.repository_url
}

output "repository_registry_id" {
  value       = module.ecr.repository_registry_id
  description = "The registry ID where the repository was created"
}
