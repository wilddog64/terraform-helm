provider "google" {
  credentials = var.credential_file
  region      = var.region
  zone        = var.zone
  version     = "~> 3.14"
}

provider "google-beta" {
  credentials = var.credential_file
  region      = var.region
  zone        = var.zone
  version     = "~> 3.14"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

// provider.template: version = "~> 2.1"
provider "template" {
  version = "~> 2.1"
}

provider "helm" {
  version = "~> 1.1.1"
}

