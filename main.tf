# Query the client configuration for our current service account, which should
# have permission to talk to the GKE cluster since it created it.
data "google_client_config" "current" {}

// configure helm povider
//

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file = false
  host = var.gke_host_endpoint

  cluster_ca_certificate = base64decode(
    // google_container_cluster.vault.master_auth[0].cluster_ca_certificate,
    var.cluster_ca_certificate
  )
  token = data.google_client_config.current.access_token
}

provider "helm" {
  version = "~> 1.1.1"
}

resource "helm_release" "bde" {
  name       = "cache"
  repository = "https://charts.cloudbees.com/public/cloudbees"
  chart      = var.helm_chart

  timeout = var.timeout

  // a namespace this chart will install to
  namespace = var.namespace

  // load custom
  values = var.values

  // reuse previous values or
  // reset to build time values
  reuse_values = var.reuse_values
  reset_values = var.reset_values

  cleanup_on_fail = var.cleanup_on_fail
  atomic = var.atomic

  // generate a set block if var.sets is not null
  dynamic "set" {
    for_each = var.set == null ? [] : var.set

    content {
      name  = each.value.name
      value = each.value.value
    }
  }

  // generate a set_sensitive dynamiclly if var.set_sensitive is not null
  dynamic "set_sensitive" {
    for_each = var.set_sensitive == null ? [] : var.set_sensitive

    content {
      name  = each.value.name
      value = each.value.value
    }
  }

  // generate a set_string dynamiclly if var.set_string is not null
  dynamic  "set_string" {
    for_each = var.set_string == null ? [] : var.set_string

    content {
      name  = each.value.name
      value = each.value.value
    }
  }
}
