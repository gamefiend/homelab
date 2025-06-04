resource "kubectl_manifest" "homepage" {
  yaml_body = file("${path.module}/manifests/homepage.yaml")
}

resource "kubectl_manifest" "storage" {
  yaml_body = file("${path.module}/manifests/storage.yaml")
}

resource "kubectl_manifest" "sftp" {
  yaml_body = templatefile("${path.module}/manifests/sftp.yaml", {
    sftp = var.sftp
  })
  depends_on = [helm_release.foundry-vtt]
}

resource "kubectl_manifest" "foundryvtt-ingress" {
  yaml_body = templatefile("${path.module}/manifests/foundryvtt-ingress.yaml", {
    foundryvtt = var.foundryvtt
  })
  apply_only = true
  depends_on = [helm_release.nginx_ingress]
}

resource "kubectl_manifest" "foundryvtt-foundry-vtt" {
  yaml_body  = file("${path.module}/manifests/foundryvtt-svc.yaml")
  depends_on = [helm_release.foundry-vtt]
}

resource "kubernetes_secret" "foundryvtt" {
  metadata {
    name      = "foundryvtt-foundry-vtt"
    namespace = "foundry-vtt"
  }

  data = yamldecode(local.foundryvtt_secrets).data
  type = "Opaque"
}

## Locals and Variables
locals {
  foundryvtt_secrets = templatefile("${path.module}/manifests/foundry-secrets.yaml", {
    foundryvtt = var.foundryvtt
  })
}

variable "foundryvtt" {
  description = "Foundry VTT configuration"
  type = object({
    admin_password   = string
    license_key      = string
    password         = string
    username         = string
    domain           = string
    load_balancer_id = string
  })
  sensitive = true
}

variable "sftp" {
  description = "SFTP configuration"
  type = object({
    password = string
  })
  sensitive = true
}