terraform {
  backend "gcs" {
    bucket      = "terraform-env"
    prefix      = "terraform/state"
    credentials = "dmp-devops-terraform.json"
  }
}
