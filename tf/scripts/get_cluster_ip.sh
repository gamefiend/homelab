#!/bin/bash
# Get the cluster IP of a service in a namespace
# Provide the service name and namespace as arguments
kubectl --kubeconfig ~/.kube/hidden-leaf-kubeconfig.yaml get svc $1 -foundry-vtt -n $2 -o json | jq '{ "clusterip": .spec.clusterIP }'