# Query the client configuration for our current service account, which should
# have permission to talk to the GKE cluster since it created it.
data "google_client_config" "current" {}

// configure helm povider
provider "helm" {
  kubernests {

    load_config_file = false

    host = var.gke_host_endpoint

    cluster_ca_certificate = base64decode(
      // google_container_cluster.vault.master_auth[0].cluster_ca_certificate,
      var.cluster_ca_certifiate
    )
    token = data.google_client_config.current.access_token
  }
}

