variable "vpc_name" {
  description = "VPC network name"
  type        = string
}

variable "vpc_subnet_name" {
  description = "VPC network name"
  type        = string
}
variable "project_id" {}

variable "environment" {
  description = "Environment name"
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
