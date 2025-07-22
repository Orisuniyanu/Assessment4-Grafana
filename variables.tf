variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "namespace" {
  description = "Namespace to install Prometheus and Grafana"
  type        = string
}
variable "kube_context" {
  type        = string
  description = "The Kubernetes context to use"
}
