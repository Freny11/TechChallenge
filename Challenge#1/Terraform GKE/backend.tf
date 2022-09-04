terraform {
  backend "gcs" {
    bucket      = "terraform-data-discovery-env"
    prefix      = "terraform/state"
    credentials = "dmp-devops-terraform.json"
  }
}
