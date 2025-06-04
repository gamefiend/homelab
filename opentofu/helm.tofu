# Nginx Ingress
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol"
    value = "true"
  }
}

# Foundry VTT
resource "helm_release" "foundry-vtt" {
  name             = "foundryvtt"
  chart            = "./charts/incubator/foundry-vtt"
  namespace        = "foundry-vtt"
  create_namespace = true

  set {
    name  = "image.tag"
    value = "12.331"
  }

  set {
    name  = "foundryvtt.hostname"
    value = "golarion.thoughtcrimegames.net"
  }

  set {
    name  = "foundryvtt.username"
    value = "quinn"
  }

  set {
    name  = "foundryvtt.password"
    value = var.foundryvtt_password
  }

  set {
    name  = "foundryvtt.adminPassword"
    value = var.foundryvtt_admin_password
  }

  set {
    name  = "foundryvtt.licenseKey"
    value = "3GRT-5XZO-G0Y1-IGKD-ADBZ-QDBF"
  }

  set {
    name  = "foundryvtt.version"
    value = "12.331"
  }

  set {
    name  = "persistence.dataDir.enabled"
    value = "true"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.existingClaim"
    value = "foundryvtt-storage"
  }

  set {
    name  = "container.verbose"
    value = "true"
  }

  set {
    name  = "container.preserveConfig"
    value = "true"
  }
}

# Postgres
resource "helm_release" "postgres" {
  name             = "postgres"
  chart            = "https://charts.bitnami.com/postgresql"
  namespace        = "postgres"
  create_namespace = true
}

## Locals and Variables
variable "foundryvtt_password" {
  type        = string
  description = "The password for the foundryvtt service"
}

variable "foundryvtt_admin_password" {
  type        = string
  description = "The password for the foundryvtt admin service"
}


