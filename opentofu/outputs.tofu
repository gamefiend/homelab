output "kube_config" {
  value       = digitalocean_kubernetes_cluster.homelab-cluster.kube_config[0].raw_config
  sensitive   = true
  description = "The kube config for the cluster"
}

output "cluster_name" {
  value       = digitalocean_kubernetes_cluster.homelab-cluster.name
  description = "The name of the Kubernetes cluster"
}

output "cluster_endpoint" {
  value       = digitalocean_kubernetes_cluster.homelab-cluster.endpoint
  description = "The endpoint of the Kubernetes cluster"
}

output "nginx-load-balancer-ip" {
  value       = data.external.nginx-load-balancer-ip.result["external-ip"]
  description = "The IP address of the NGINX load balancer"
}

