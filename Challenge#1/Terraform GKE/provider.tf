provider "google" {
  project = var.project_id
  region  = var.project_region
  zone    = var.project_zone
  //  version     = "3.56.0"
  credentials = file("dmp-devops-terraform.json")
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_client_config" "default" {}

provider "kubernetes" {
  //  version                = "1.13"
  host  = module.gke.gke_cluster_endpoint
  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(module.gke.gke_cluster_ca_certificate)
  load_config_file       = false

}

provider "helm" {
  kubernetes {
    host  = module.gke.gke_cluster_endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(module.gke.gke_cluster_ca_certificate)

  }
}
