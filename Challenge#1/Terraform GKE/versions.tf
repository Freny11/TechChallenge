terraform {
  required_version = "~> 0.15.4"
  required_providers {
    google = {
      version = ">=4.0.0"
    }
    kubernetes = {
      version = "~> 1.13"
    }
    //    helm = {
    //        version =  "~> 1.2"
    //    }
  }
}

