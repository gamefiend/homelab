locals {
  kubernetes_config = file("${path.module}/homepage/kubernetes.yaml")
  settings_config   = file("${path.module}/homepage/settings.yaml")
  bookmarks_config  = file("${path.module}/homepage/bookmarks.yaml")
  services_config   = file("${path.module}/homepage/services.yaml")
  widgets_config    = file("${path.module}/homepage/widgets.yaml")
  foundryvtt_secrets = templatefile("${path.module}/manifests/foundry-secrets.yaml", {
    foundryvtt = var.foundryvtt
  })
}

resource "kubectl_manifest" "homepage" {
  yaml_body = templatefile("${path.module}/manifests/homepage.yaml", {
    kubernetes_config = local.kubernetes_config
    settings_config   = local.settings_config
    bookmarks_config  = local.bookmarks_config
    services_config   = local.services_config
    widgets_config    = local.widgets_config
  })
}

resource "kubectl_manifest" "foundryvtt-storage" {
  yaml_body = file("${path.module}/manifests/foundryvtt-storage.yaml")
}

resource "kubectl_manifest" "sftp" {
  yaml_body = templatefile("${path.module}/manifests/sftp.yaml", {
    sftp = var.sftp
  })
}

resource "kubectl_manifest" "foundryvtt-ingress" {
  yaml_body = templatefile("${path.module}/manifests/foundryvtt-ingress.yaml", {
    foundryvtt = var.foundryvtt
  })
  apply_only = true
}

resource "kubectl_manifest" "foundryvtt-foundry-svc" {
  yaml_body = file("${path.module}/manifests/foundryvtt-svc.yaml")
  force_new = true
}

resource "kubectl_manifest" "postgres-storage" {
  yaml_body = file("${path.module}/manifests/postgres-storage.yaml")
} 