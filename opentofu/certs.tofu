resource "dnsimple_lets_encrypt_certificate" "thoughtcrimegames-net" {
  domain_id  = var.thoughtcrime_domain_id
  auto_renew = true
  name       = "*"
}

data "dnsimple_certificate" "thoughtcrimegames-net" {
  domain         = "thoughtcrimegames.net"
  certificate_id = dnsimple_lets_encrypt_certificate.thoughtcrimegames-net.id
}

resource "kubernetes_secret" "thoughtcrimegames-net-cert" {
  for_each = var.namespaces
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
  for_each = var.namespaces
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

## Locals and Variables
variable "namespaces" {
  type        = set(string)
  description = "Target namespaces for resource deployment"
  default     = ["default", "foundry-vtt"]
}
