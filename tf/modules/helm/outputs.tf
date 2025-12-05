output "nginx_ingress_name" {
  description = "Name of the nginx ingress release"
  value       = helm_release.nginx_ingress.name
}



output "postgres_name" {
  description = "Name of the PostgreSQL release"
  value       = helm_release.postgres.name
} 