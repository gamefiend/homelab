#!/bin/bash

# First, download the remote state
echo "Downloading remote state from DigitalOcean Spaces..."
aws s3 cp s3://thoughtcrimegames/opentofu/terraform.tfstate terraform.tfstate.tofu \
  --endpoint-url https://nyc3.digitaloceanspaces.com

# Backup the downloaded state
cp terraform.tfstate.tofu terraform.tfstate.tofu.backup

# Import cluster
echo "Importing cluster..."
terraform import digitalocean_kubernetes_cluster.homelab-cluster $(terraform state show -state=terraform.tfstate.tofu digitalocean_kubernetes_cluster.homelab-cluster | grep id | cut -d'"' -f2)

# Import node pool
echo "Importing node pool..."
terraform import digitalocean_kubernetes_node_pool.large-node-pool $(terraform state show -state=terraform.tfstate.tofu digitalocean_kubernetes_node_pool.large-node-pool | grep id | cut -d'"' -f2)

# Import DNS records
echo "Importing DNS records..."
terraform import dnsimple_zone_record.homelab-cluster-record $(terraform state show -state=terraform.tfstate.tofu dnsimple_zone_record.homelab-cluster-record | grep id | cut -d'"' -f2)
terraform import dnsimple_zone_record.golarion-record $(terraform state show -state=terraform.tfstate.tofu dnsimple_zone_record.golarion-record | grep id | cut -d'"' -f2)

# Import certificates
echo "Importing certificates..."
terraform import dnsimple_lets_encrypt_certificate.thoughtcrimegames-net $(terraform state show -state=terraform.tfstate.tofu dnsimple_lets_encrypt_certificate.thoughtcrimegames-net | grep id | cut -d'"' -f2)

# Import namespaces
echo "Importing namespaces..."
terraform import kubernetes_namespace.default default
terraform import kubernetes_namespace.foundry-vtt foundry-vtt

# Import secrets
echo "Importing secrets..."
for namespace in default foundry-vtt; do
  terraform import kubernetes_secret.thoughtcrimegames-net-cert[\"$namespace\"] $namespace/thoughtcrimegames-secret
  terraform import kubernetes_secret.thoughtcrimegames-net-ca[\"$namespace\"] $namespace/thoughtcrimegames-ca-secret
done

# Import Helm releases
echo "Importing Helm releases..."
terraform import module.helm.helm_release.foundry-vtt foundry-vtt
terraform import module.helm.helm_release.kube_dashboard kube-dashboard
terraform import module.helm.helm_release.nginx_ingress nginx-ingress
terraform import module.helm.helm_release.postgres postgres

# Import kubectl manifests
echo "Importing kubectl manifests..."
terraform import module.manifests.kubectl_manifest.foundryvtt-foundry-svc foundry-vtt/foundryvtt-foundry-svc
terraform import module.manifests.kubectl_manifest.foundryvtt-ingress foundry-vtt/foundryvtt-ingress
terraform import module.manifests.kubectl_manifest.foundryvtt-storage foundry-vtt/foundryvtt-storage
terraform import module.manifests.kubectl_manifest.homepage homepage/homepage
terraform import module.manifests.kubectl_manifest.postgres-storage postgres/postgres-storage
terraform import module.manifests.kubectl_manifest.sftp foundry-vtt/sftp

# Import local files and null resources
echo "Importing local files and null resources..."
terraform import module.manifests.local_file.rendered_homepage_yaml rendered_homepage.yaml
terraform import module.manifests.null_resource.restart_homepage restart_homepage

echo "Import complete. Please verify the state with 'terraform state list'" 
