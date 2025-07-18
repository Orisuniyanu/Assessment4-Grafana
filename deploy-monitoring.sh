#!/bin/bash

set -e

NAMESPACE="monitoring"
RELEASE_NAME="kube-monitoring"
VALUES_FILE="values-template.yaml"

echo "🔧 Checking/creating namespace..."
kubectl get ns $NAMESPACE >/dev/null 2>&1 || kubectl create ns $NAMESPACE

echo "📦 Adding/updating Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "🚀 Deploying Prometheus and Grafana with custom values..."
helm upgrade --install $RELEASE_NAME prometheus-community/kube-prometheus-stack \
  -n $NAMESPACE \
  -f $VALUES_FILE

echo "✅ Monitoring deployed."
echo "➡️  Access Grafana: kubectl port-forward svc/$RELEASE_NAME-grafana 3000:80 -n $NAMESPACE"
