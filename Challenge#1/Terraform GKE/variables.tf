variable "project_id" {
  description = "Google Project Name"
  type        = string
}


variable "environment" {
  description = "Environment name"
  type        = string
}


variable "env_iap" {
  description = "Environment name for IAP"
  type        = string
}

variable "project_region" {
  description = "Google Project region"
  type        = string
}


variable "project_zone" {
  description = "Google Project zone"
  type        = string
}

variable "private_key" {
  type        = string
  description = "The path to private key (in .pem) needed for Entrust SSL Certificate."
  default     = ""
}

variable "certificate_pem" {
  type        = string
  description = "The path to certificate (in .pem) needed for Entrust SSL Certificate."
  default     = ""
}

variable "preemptible" {}

variable "istio" {
  type = bool
}

variable "istioingressport" {
  type = number
}

variable "host_name_obs" {
  type = string
}

variable "host_name" {
  type = string
}

