data "terraform_remote_state" "bde-project" {
  backend = "gcs"
  // services-host-dev
  workspace = var.workspace
  config = {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = file("~/.config/gcloud/tf-svc-acct.json")
  }
}

data "terraform_remote_state" "bde-gke" {
  backend = "gcs"
  workspace = var.workspace
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
  gke_host_endpoint = data.terraform_remote_state.bde-gke.outputs.cluster_endpoint

  kube_config_context = var.kube_config_context
  cluster_ca_certificate = data.terraform_remote_state.bde-gke.outputs.cluster_ca_certificate
  helm_repo_url = "https://charts.cloudbees.com/public/cloudbees"
  helm_repo = "cloudbees"

  helm_chart      = var.helm_chart
  jenkins_version = var.jenkins_version
  timeout         = 60

  release_name = "bde"
  namespace = "bde-jenkins"
  values = [
    "${file("${path.module}/files/values.yaml")}"
  ]
}
