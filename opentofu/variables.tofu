# Provider Variables
variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
  sensitive   = true
}

variable "dnsimple_token" {
  type        = string
  description = "DNSimple API token"
  sensitive   = true
}

variable "dnsimple_account" {
  type        = string
  description = "DNSimple account ID"
}

variable "twingate_api_token" {
  type        = string
  description = "Twingate API token"
  sensitive   = true
}

# Cluster Variables
variable "thoughtcrime_domain_id" {
  type        = string
  description = "DNSimple domain ID for thoughtcrimegames.net"
}

# Foundry VTT Variables
variable "foundryvtt" {
  description = "Foundry VTT configuration"
  type = object({
    admin_password   = string
    license_key      = string
    password         = string
    username         = string
    domain           = string
    load_balancer_id = string
  })
  sensitive = true
}

# SFTP Variables
variable "sftp" {
  description = "SFTP configuration"
  type = object({
    password = string
  })
  sensitive = true
}

# PostgreSQL Variables
variable "postgres_password" {
  description = "Password for PostgreSQL"
  type        = string
  sensitive   = true
}

# Certificate Variables
variable "namespaces" {
  description = "List of namespaces to create certificates for"
  type        = list(string)
} 