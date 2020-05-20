terraform {
  backend "gcs" {
    bucket      = "bde-tf-state-dev"
    prefix      = "terraform/state"
    credentials = "~/.config/gcloud/tf-svc-acct.json"
  }
}
