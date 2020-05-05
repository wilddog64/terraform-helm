# Query the client configuration for our current service account, which should
# have permission to talk to the GKE cluster since it created it.
data "google_client_config" "current" {}

// configure helm povider
//

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file = false
  host = var.gke_host_endpoint

  config_context = var.kube_config_context
  cluster_ca_certificate = base64decode(
    var.cluster_ca_certificate
  )
  token = data.google_client_config.current.access_token
}

provider "helm" {
  version = "~> 1.1.1"
}

data "helm_repository" "default" {
  name = var.helm_repo
  url  = var.helm_repo_url
}

// create a k8s namespace
resource "kubernetes_namespace" "default" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "default" {
  name       = var.release_name
  repository = data.helm_repository.default.metadata[0].name
  chart      = var.helm_chart

  timeout = var.timeout

  // a namespace this chart will install to
  namespace = var.namespace
  skip_crds = var.skip_crds

  // load custom
  values = var.values

  version = var.jenkins_version
  // reuse previous values or
  // reset to build time values
  reuse_values = var.reuse_values
  reset_values = var.reset_values

  cleanup_on_fail = var.cleanup_on_fail
  atomic = var.atomic

  // generate a set block if var.sets is not null
  dynamic "set" {
    for_each = var.set_values == null ? [] : var.set_values

    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  // generate a set_sensitive dynamiclly if var.set_sensitive is not null
  dynamic "set_sensitive" {
    for_each = var.set_sensitive == null ? [] : var.set_sensitive

    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }

  // generate a set_string dynamiclly if var.set_string is not null
  dynamic  "set_string" {
    for_each = var.set_string == null ? [] : var.set_string

    content {
      name  = set_string.value.name
      value = set_string.value.value
    }
  }

  depends_on = [
    kubernetes_namespace.default,
    var.depends
  ]
}
