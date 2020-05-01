variable "credential_file" {
  description = "an service account credential file"
  type        = string
  default     = null
}

variable "region" {
  description = "region of the project"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "a valid zone for a given region"
  type        = string
  default     = "us-west1-a"
}

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

variable "namespace" {
  description = "a kubernetes namespace this chart will install to"
  type        = string
  default     = null
}

variable "values" {
  description = "a list of custom chart value.yaml files"
  type        = list
  default     = null
}

variable "timeout" {
  description = "timeout value for chart installation, default 500s"
  type = number
  default = 300
}

variable "reuse_values" {
  description = "When upgrading, reuse the last release's values and merge in any overrides. If 'reset_values' is specified, this is ignored. Defaults to false"
  type        = bool
  default     = false
}

variable "reset_values" {
  description = "When upgrading, reset the values to the ones built into the chart. Defaults to false"
  type        = bool
  default     = false
}

variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to false"
  type        = bool
  default     = false
}

variable "automic" {
  description = "f set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to false"
  type        = bool
  default     = false
}

variable "set_values" {
  description = "Value block with custom values to be merged with the values yaml"
  type = list(object({
    name = string
    value = any
  }))
  default = null
}

variable "set_sensitive" {
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff"
  type = list(object({
    name = string
    value = any
  }))
  default = null
}

variable "set_string" {
  description = "Value block with custom STRING values to be merged with the values yaml"
  type = list(object({
    name = string
    value = any
  }))
  default = null
}

variable "cluster_ca_certificate" {
  description = "a k8s cluster ca cert"
  type = string
  default = null
}

variable "atomic" {
  description = "perform a helm atomic operation"
  type = bool
  default = false
}

variable "jenkins_version" {
  description = "Specify the exact chart version to install. If this is not specified, the latest version is installed"
  type        = string
  default     = null
}

variable "helm_repo_url" {
  description = "helm repository url"
  type        = string
  default     = null
}

variable "release_name" {
  description = "helm 3 release name"
  type        = string
  default     = null
}

variable "helm_repo" {
  description = "a repo for looking chart to install"
  type        = string
  default     = null
}

variable "kube_config_context" {
  description = "kubectl config context"
  type = string
  default = null
}
