output "nginx_ingress_name" {
  description = "Name of the nginx ingress release"
  value       = helm_release.nginx_ingress.name
}

output "foundry_vtt_name" {
  description = "Name of the Foundry VTT release"
  value       = helm_release.foundry-vtt.name
}

output "postgres_name" {
  description = "Name of the PostgreSQL release"
  value       = helm_release.postgres.name
} 