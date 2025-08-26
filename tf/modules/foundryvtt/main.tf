locals {
  foundryvtt_secrets = templatefile("${path.module}/manifests/foundry-secrets.yaml", {
    foundryvtt = var.foundryvtt
  })
}

resource "helm_release" "foundry-vtt" {
  name      = "foundry-vtt"
  chart     = "${path.module}/charts"
  namespace = "foundry-vtt"
  version   = var.foundryvtt.version
  # depends_on = [kubectl_manifest.foundryvtt-storage, kubectl_manifest.foundryvtt-foundry-svc, kubectl_manifest.foundryvtt-ingress]
  depends_on = [kubectl_manifest.foundryvtt-storage, kubectl_manifest.foundryvtt-ingress]

  set = [
    {
      name  = "image.tag"
      value = "12.331"
      }, {
      name  = "foundryvtt.hostname"
      value = var.foundryvtt.domain
      }, {
      name  = "foundryvtt.username"
      value = var.foundryvtt.username
      }, {
      name  = "foundryvtt.password"
      value = var.foundryvtt.password
      }, {
      name  = "foundryvtt.adminPassword"
      value = var.foundryvtt.admin_password
      }, {
      name  = "foundryvtt.licenseKey"
      value = var.foundryvtt.license_key
      }, {
      name  = "foundryvtt.version"
      value = var.foundryvtt.version
      }, {
      name  = "persistence.dataDir.enabled"
      value = "true"
      }, {
      name  = "persistence.enabled"
      value = "true"
      }, {
      name  = "persistence.existingClaim"
      value = "foundryvtt-pvc"
      }, {
      name  = "container.verbose"
      value = "true"
      }, {
      name  = "container.preserveConfig"
      value = "true"
    }
  ]
}

# Many of these templatefiles have no variables, but I'm doing this to make
# it easier to add variables in the future. - QHM 08-26-2025

resource "kubectl_manifest" "foundryvtt-ingress" {
  yaml_body = templatefile("${path.module}/manifests/foundryvtt-ingress.yaml", {
    foundryvtt = var.foundryvtt
  })

  ignore_fields = ["metadata.generation", "metadata.managedFields", "status"]
}

resource "kubectl_manifest" "foundryvtt-storage" {
  yaml_body = templatefile("${path.module}/manifests/foundryvtt-storage.yaml", {
  })

  ignore_fields = ["metadata.generation", "metadata.managedFields", "status"]
}

resource "kubectl_manifest" "sftp" {
  yaml_body = templatefile("${path.module}/manifests/sftp.yaml", {
    sftp = var.sftp
  })

  ignore_fields = ["metadata.generation", "metadata.managedFields", "status"]
} 