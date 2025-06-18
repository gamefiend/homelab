#!/bin/bash

kubectl --kubeconfig ~/.kube/hidden-leaf-kubeconfig.yaml get svc -n ingress-nginx -o json | jq '{ "external-ip": .items[0].status.loadBalancer.ingress[0].ip}'