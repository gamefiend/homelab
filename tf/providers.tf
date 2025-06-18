terraform {
  backend "s3" {
    # keeping state remote in DigitalOcean Spaces
    endpoints = {
      # origin url = https://thoughtcrimegames.nyc3.digitaloceanspaces.com
      s3 = "https://nyc3.digitaloceanspaces.com"
    }
    bucket                      = "thoughtcrimegames"
    key                         = "opentofu/terraform.tfstate"
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34.1"
    }

    dnsimple = {
      source  = "dnsimple/dnsimple"
      version = "~> 1.9.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }

    twingate = {
      source  = "Twingate/twingate"
      version = "3.3.1"
    }
  }
}

provider "kubernetes" {
  host  = resource.digitalocean_kubernetes_cluster.homelab-cluster.endpoint
  token = resource.digitalocean_kubernetes_cluster.homelab-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    resource.digitalocean_kubernetes_cluster.homelab-cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/hidden-leaf-kubeconfig.yaml"
  }
}

provider "kubectl" {
  config_path = "~/.kube/hidden-leaf-kubeconfig.yaml"
}

provider "twingate" {
  api_token = var.twingate_api_token
  network   = "thoughtcrimegames"

  default_tags = {
    tags = {
      managed_by = "opentofu"
    }
  }

  cache = {
    resource_enable = true
    groups_enabled  = true
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "dnsimple" {
  account = var.dnsimple_account
  token   = var.dnsimple_token
}

