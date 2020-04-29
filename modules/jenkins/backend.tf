terraform {
  backend "gcs" {
    bucket      = "services-host-3b114438-storage"
    prefix      = "terraform/state"
    credentials = "~/.config/gcloud/tf-svc-acct.json"
  }
}
