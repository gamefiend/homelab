Homelab Infrastructure
=====================
Welcome to my homelab! I use this space to experiment with technologies but also to host my personal projects and utilities that I find useful.
This repository contains the infrastructure as code (IaC) for my personal homelab, hosted on DigitalOcean Kubernetes Service (DOKS).
It also contains my notes and documentation for my projects and the services I run. 

I use OpenTofu instead of Terraform because it's a drop-in replacement - same syntax, better license :) 

Infrastructure Overview - as of 2025-06-04
---------------------
- Kubernetes Cluster: DOKS running version 1.32.2-do.0
- Region: NYC1
- Node Pools:
  * Main Pool: 3x s-1vcpu-2gb nodes
  * Large Pool: 1x s-2vcpu-4gb node (tagged with "xl")

Services
--------
1. Foundry VTT
   - Virtual Tabletop platform for RPG gaming
   - Domain: golarion.thoughtcrimegames.net
   - Features:
     * Persistent storage
     * SFTP access for file management (behind Twingate IP, not exposed to the public internet)
     * SSL/TLS encryption via nginx ingress controller. Let's Encrypt certificate created with the DNSimple OpenTofu provider.
     * Nginx ingress with proxy protocol

2. Homepage
   - Dashboard/landing page for homelab services
   - Deployed via Kubernetes manifests
   - Also begin Twingate IP, since only I will be looking at it :)

3. PostgreSQL
   - Database service
   - Deployed via Helm chart from Bitnami

Infrastructure Components
-----------------------
1. Networking
   - Nginx Ingress Controller
   - TLS/SSL certificates via DNSimple
   - Custom domain management (thoughtcrimegames.net)

2. Security
   - Twingate integration for secure access
   - Basic authentication for Foundry VTT
   - TLS encryption for all services

3. Storage
   - Persistent volume claims for data storage
   - SFTP access for file management in Foundry VTT

Management
----------
- Infrastructure managed via OpenTofu
- State stored in DigitalOcean Spaces
- Helm charts for application deployment
- Kubernetes manifests for custom resources, called via OpenTofu using `kubectl_manifest`.

Secrets
-------
All sensitive credentials and configuration values are stored in tofu.auto.tfvars and never committed to the repository. 