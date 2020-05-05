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

data "terraform_remote_state" "bde-dns" {
  backend = "gcs"
  workspace = var.workspace
  config = {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = file("~/.config/gcloud/tf-svc-acct.json")
  }
}


data "terraform_remote_state" "bde-vpc" {
  backend = "gcs"
  workspace = var.workspace
  config = {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = file("~/.config/gcloud/tf-svc-acct.json")
  }
}

data "template_file" "custom_helm_values" {
  template = "${file("${path.module}/files/values.yaml")}"
  vars = {
    # jenkins_hostname = trimsuffix(google_dns_record_set.jenkins.name, ".")
    jenkins_hostname = "jenkins.cluster.local"
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

  address_type = "INTERNAL"
  subnetwork = data.terraform_remote_state.bde-vpc.outputs.vpc_private_subnet_self_link
  address = var.ip_address
}

resource "google_dns_record_set" "jenkins" {
  project = data.terraform_remote_state.bde-project.outputs.project_id[0]
  name = "jenkins.${data.terraform_remote_state.bde-dns.outputs.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.terraform_remote_state.bde-dns.outputs.managed_zone_name
  rrdatas = [
    google_compute_address.static.address
  ]
}

module "jenkins" {
  source = "../.."
  credential_file = file("~/.config/gcloud/tf-svc-acct.json")
  region = data.terraform_remote_state.bde-project.outputs.region
  zone = data.terraform_remote_state.bde-project.outputs.zone
  gke_host_endpoint = data.terraform_remote_state.bde-gke.outputs.cluster_endpoint

  kube_config_context = var.kube_config_context
  cluster_ca_certificate = data.terraform_remote_state.bde-gke.outputs.cluster_ca_certificate
  helm_repo_url = "https://kubernetes-charts.storage.googleapis.com"
  helm_repo = "stable"
  skip_crds = var.skip_crds

  helm_chart      = var.helm_chart
  jenkins_version = var.jenkins_version
  timeout         = var.timeout

  release_name = "bde"
  namespace = "bde-jenkins"
  values = [
    # "${data.template_file.custom_helm_values.rendered}"
    "${file("${path.module}/files/values.yaml")}"
  ]

  depends = [
    google_compute_address.static
  ]
}
