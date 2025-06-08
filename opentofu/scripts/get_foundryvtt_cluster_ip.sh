#!/bin/bash
kubectl --kubeconfig ~/.kube/hidden-leaf-kubeconfig.yaml get svc app-foundry-vtt -n foundry-vtt -o json | jq '{ "clusterip": .spec.clusterIP }'