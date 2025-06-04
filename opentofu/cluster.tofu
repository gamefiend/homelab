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

data "external" "nginx-load-balancer-ip" {
  program    = ["bash", "${path.module}/scripts/get_loadbalancer_ip.sh"]
  depends_on = [helm_release.nginx_ingress]
}

resource "kubernetes_secret" "foundryvtt-basic-auth" {
  metadata {
    name      = "basic-auth"
    namespace = "foundry-vtt"
  }
  data = {
    username = var.basic_auth_username
    password = var.basic_auth_passwd
  }

  type       = "Opaque"
  depends_on = [helm_release.nginx_ingress]
}

## Locals and Variables
variable "thoughtcrime_domain_id" {
  type        = string
  description = "The ID of the DNSimple zone for thoughtcrimegames.net"
}

variable "basic_auth_username" {
  type        = string
  description = "The username for foundryvtt basic auth"
}

variable "basic_auth_passwd" {
  type        = string
  description = "The password for foundryvtt basic auth"
}


