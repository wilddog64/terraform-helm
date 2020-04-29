data "terraform_remote_state" "bde-project" {
  backend = "gcs"
  workspace = "services-host-dev"
  config = {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = file("~/.config/gcloud/tf-svc-acct.json")
  }
}

data "terraform_remote_state" "bde-gke" {
  backend = "gcs"
  workspace = "services-host-dev"
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
  cluster_ca_certificate = data.terraform_remote_state.bde-gke.outputs.cluster_ca_certificate
  helm_repo_url = "https://charts.cloudbees.com/public/cloudbees"

  helm_chart      = "stable/cloudbees-jenkins-distribution"
  jenkins_version = var.jenkins_version

  namespace = "cd-jenkins"
  values = [
    "${file("${path.module}/files/values.yaml")}"
  ]
}
