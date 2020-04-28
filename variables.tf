variable "gke_host_endpoint" {
  description = "The hostname (in form of URI) of Kubernetes master"
  type        = string
  default     = null
}

variable "gke_cluster_ca_certificate" {
  description = "PEM-encoded root certificates bundle for TLS authentication. Can be sourced from"
  type = string
  default = null
}

variable "helm_chart" {
  description = "a helm chart this module try to install"
  type        = string
  default     = null
}
