
locals {
  kubernetes_config = file("${path.module}/homepage/kubernetes.yaml")
  settings_config   = file("${path.module}/homepage/settings.yaml")
  bookmarks_config  = file("${path.module}/homepage/bookmarks.yaml")
  services_config   = file("${path.module}/homepage/services.yaml")
  widgets_config    = file("${path.module}/homepage/widgets.yaml")
  restart_timestamp = timestamp()
  foundryvtt_secrets = templatefile("${path.module}/manifests/foundry-secrets.yaml", {
    foundryvtt = var.foundryvtt
  })
}

resource "local_file" "rendered_homepage_yaml" {
  content = templatefile("${path.module}/manifests/homepage.yaml", {
    kubernetes_config = local.kubernetes_config
    settings_config   = local.settings_config
    bookmarks_config  = local.bookmarks_config
    services_config   = local.services_config
    widgets_config    = local.widgets_config
    restart_timestamp = local.restart_timestamp
  })
  filename = "${path.module}/manifests/rendered_homepage.yaml"
}

resource "kubectl_manifest" "homepage" {
  yaml_body = local_file.rendered_homepage_yaml.content
}

# Homepage often needs to restart to take config changes, but kubectl_manifest doesn't support restarts.
resource "null_resource" "restart_homepage" {
  provisioner "local-exec" {
    command = "kubectl  --kubeconfig ~/.kube/hidden-leaf-kubeconfig.yaml rollout restart deployment/homepage -n homepage"
  }
  depends_on = [kubectl_manifest.homepage]
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



