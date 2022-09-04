variable "gke_cluster_location" {
  description = "Cluster location"
  type        = string
}

variable "gke_cluster_network_name" {
  description = "GKE vpc network name"
  type        = string
}

variable "gke_cluster_subnetwork" {
  description = "GKE vpc subnet name"
  type        = string
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "preemptible" {
  description = "preemptible nodepool"
  type        = string
}

variable "gke_cluster_new_node_pool_name" {
  description = "GKE Node pool name"
  type        = string
}

variable "gke_cluster_new_node_pool_size" {
  description = "Number of nodes on GKE node pool"
  type        = string
}

variable "gke_cluster_new_node_pool_machine_tpe" {
  description = "GKE node pool machine type"
  type        = string
}

variable "gke_cluster_new_node_pool_min_count" {
  description = "GKE node pool mix size"
  type        = string
}

variable "gke_cluster_new_node_pool_max_count" {
  description = "GKE node pool max size"
  type        = string
}

variable "gke_cluster_new_node_pool_scopes" {
  description = "GKE node pool access"
  type        = list(string)
}

variable "application_pool_service_account" {
  description = "Application pool service_account"
  type        = string
}

variable "project_id" {}

variable "namespaces" {
  description = "The namespaces to be provisioned on the cluster"
  type        = set(string)
}

variable "istio" {
  description = "Add istio injection"
  type        = bool
  default     = false
}

