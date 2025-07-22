terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
  }
}

provider "kubernetes" {
  alias          = "myk8s"
  config_path    = "~/.kube/config"
  config_context = var.kube_context
}

provider "helm" {
  alias = "myk8s"
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = var.kube_context
  }
}

resource "kubernetes_namespace" "monitoring" {
  provider = kubernetes.myk8s
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus" {
  provider   = helm.myk8s
  name       = "kube-monitoring"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "58.0.0"
  values     = [file("${path.module}/values.yaml")]
  depends_on = [kubernetes_namespace.monitoring]
}
