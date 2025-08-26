# Nginx Ingress
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx/"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  set = [
    {
      name  = "controller.publishService.enabled"
      value = "true"
      }, {
      name  = "controller.service.annotations.service.beta.kubernetes.io/do-loadbalancer-enable-proxy-protocol"
      value = "true"
    }
  ]
}


# Postgres
resource "helm_release" "postgres" {
  name             = "postgresql"
  repository       = "oci://registry-1.docker.io/bitnamicharts/"
  chart            = "postgresql"
  namespace        = "postgres"
  create_namespace = true

  set = [
    {
      name  = "auth.password"
      value = var.postgres_password
      }, {
      name  = "auth.enablePostgresUser"
      value = true
      }, {
      name  = "audit.log.enabled"
      value = "true"
      }, {
      name  = "audit.log.path"
      value = "/var/log/postgresql/audit.log"
      }, {
      name  = "persistence.enabled"
      value = "true"
      }, {
      name  = "persistence.existingClaim"
      value = "postgres-storage"
    }
  ]
}

# Kube Dashboard
resource "helm_release" "kube_dashboard" {
  name             = "kube-dashboard"
  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
}

# LinkDing
#    nginx.ingress.kubernetes.io/auth-tls-secret: "linkding/thoughtcrimegames-ca-secret"
#    nginx.ingress.kubernetes.io/auth-tls-verify-client: "off"
# resource "helm_release" "linkding" {
#   name             = "linkding"
#   repository       = "https://pascaliske.github.io/linkding-helm-chart"
#   chart            = "linkding"
#   namespace        = "linkding"
#   create_namespace = true

#   set = [
#     {
#       name  = "ingress.enabled"
#       value = true
#     }, {
#       name  = "ingress.annotations.nginx.ingress.kubernetes.io/auth-tls-secret"
#       value = "linkding/thoughtcrimegames-ca-secret"
#     }, {
#       name  = "ingress.annotations.nginx.ingress.kubernetes.io/auth-tls-verify-client"
#       value = "off"
#     }
#   ]
# }