# Cluster Resources
resource "digitalocean_kubernetes_cluster" "homelab-cluster" {
  name    = "homelab-cluster"
  region  = "nyc1"
  version = "1.32.2-do.0"

  node_pool {
    name       = "homelab-node-pool"
    size       = "s-1vcpu-2gb"
    node_count = 3
    tags       = ["homelab"]
  }
}

resource "digitalocean_kubernetes_node_pool" "large-node-pool" {
  name       = "large-node-pool"
  size       = "s-2vcpu-4gb"
  node_count = 1
  cluster_id = digitalocean_kubernetes_cluster.homelab-cluster.id
  tags       = ["homelab"]
  labels = {
    "xl" = "true"
  }
}

locals {
  endpoint = replace(digitalocean_kubernetes_cluster.homelab-cluster.endpoint, "https://", "")
}

## DNS Resources
resource "dnsimple_zone_record" "homelab-cluster-record" {
  zone_name = "thoughtcrimegames.net"
  name      = "homelab"
  type      = "CNAME"
  ttl       = 60
  value     = local.endpoint
}

resource "dnsimple_zone_record" "golarion-record" {
  zone_name = "thoughtcrimegames.net"
  name      = "golarion"
  type      = "A"
  ttl       = 60
  value     = data.external.nginx-load-balancer-ip.result["external-ip"]
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = "postgres"
  }
}

data "external" "nginx-load-balancer-ip" {
  program    = ["bash", "${path.module}/scripts/get_loadbalancer_ip.sh"]
  depends_on = [module.helm.nginx_ingress_name]
}

# Certificate Resources
resource "dnsimple_lets_encrypt_certificate" "thoughtcrimegames-net" {
  domain_id  = var.thoughtcrime_domain_id
  auto_renew = true
  name       = "*"
}


## Certificate Resources
data "dnsimple_certificate" "thoughtcrimegames-net" {
  domain         = "thoughtcrimegames.net"
  certificate_id = dnsimple_lets_encrypt_certificate.thoughtcrimegames-net.id
}

resource "kubernetes_secret" "thoughtcrimegames-net-cert" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "thoughtcrimegames-secret"
    namespace = each.value
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = "${data.dnsimple_certificate.thoughtcrimegames-net.server_certificate}"
    "tls.key" = "${data.dnsimple_certificate.thoughtcrimegames-net.private_key}"
  }
}

resource "kubernetes_secret" "thoughtcrimegames-net-ca" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "thoughtcrimegames-ca-secret"
    namespace = each.value
  }
  type = "kubernetes.io/tls"
  data = {
    "ca.crt"  = "${data.dnsimple_certificate.thoughtcrimegames-net.root_certificate}"
    "tls.crt" = "${data.dnsimple_certificate.thoughtcrimegames-net.server_certificate}"
    "tls.key" = "${data.dnsimple_certificate.thoughtcrimegames-net.private_key}"
  }
}
