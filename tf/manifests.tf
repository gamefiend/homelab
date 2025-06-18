module "manifests" {
  source     = "./modules/manifests"
  foundryvtt = var.foundryvtt
  sftp       = var.sftp
}