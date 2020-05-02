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

resource "random_id" "id" {
  byte_length = 4
  prefix      = "jenkins-static-ip-"
}

// provision a static ip here
resource "google_compute_address" "static" {
  project = data.terraform_remote_state.bde-project.outputs.project_id[0]
  region  = data.terraform_remote_state.bde-project.outputs.region
  name    = random_id.id.hex
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
