data "terraform_remote_state" "bde-project" {
  backend = "gcs"
  config = {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = file("~/.config/gcloud/tf-svc-acct.json")
  }
}

module "jenkins" {
  source = "../.."
  credential_file = file("~/.config/gcloud/tf-svc-acct.json")
  region = data.terraform_remote_state.bde-project.outputs.region
  zone = data.terraform_remote_state.bde-project.outputs.zone
  gke_host_endpoint = data.terraform_remote_state.service-host.gke_cluster_endpoint
  gke_cluster_ca_certificate = data.terraform_remote_state.service-host.gke_cluster_ca_cert

  namespace = "stable/jenkins"
  values = [
    "${file("${path.module}/files/values.yaml")}"
  ]
}
