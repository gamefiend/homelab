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
  name             = "app"
  chart            = "${path.module}/charts/incubator/foundry-vtt"
  namespace        = "foundry-vtt"
  create_namespace = true

  set {
    name  = "image.tag"
    value = "12.331"
  }

  set {
    name  = "foundryvtt.hostname"
    value = var.foundryvtt.domain
  }

  set {
    name  = "foundryvtt.username"
    value = var.foundryvtt.username
  }

  set {
    name  = "foundryvtt.password"
    value = var.foundryvtt.password
  }

  set {
    name  = "foundryvtt.adminPassword"
    value = var.foundryvtt.admin_password
  }

  set {
    name  = "foundryvtt.licenseKey"
    value = var.foundryvtt.license_key
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
  name             = "postgresql"
  repository       = "oci://registry-1.docker.io/bitnamicharts/"
  chart            = "postgresql"
  namespace        = "postgres"
  create_namespace = true

  set {
    name  = "auth.password"
    value = var.postgres_password
  }

  set {
    name  = "auth.enablePostgresUser"
    value = true
  }

  set {
    name  = "audit.log.enabled"
    value = "true"
  }

  set {
    name  = "audit.log.path"
    value = "/var/log/postgresql/audit.log"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.existingClaim"
    value = "postgres-storage"
  }
}

# Kube Dashboard
resource "helm_release" "kube_dashboard" {
  name             = "kube-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
}