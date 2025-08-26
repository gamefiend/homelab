variable "foundryvtt" {
  description = "Foundry VTT configuration"
  type = object({
    admin_password   = string
    license_key      = string
    password         = string
    username         = string
    domain           = string
    load_balancer_id = string
    version          = string
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