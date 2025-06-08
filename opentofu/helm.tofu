module "helm" {
  source = "./modules/helm"

  foundryvtt        = var.foundryvtt
  postgres_password = var.postgres_password
}

