module "manifests" {
  source = "./modules/manifests"
}

module "foundryvtt" {
  source     = "./modules/foundryvtt"
  foundryvtt = var.foundryvtt
  sftp       = var.sftp
}

module "helm" {
  source            = "./modules/helm"
  postgres_password = var.postgres_password
}