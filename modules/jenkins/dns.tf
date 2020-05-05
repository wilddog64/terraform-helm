resource "random_id" "id" {
  byte_length = 4
  prefix      = "jenkins-static-ip-"
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
