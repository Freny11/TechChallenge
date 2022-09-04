output "gke_cluster_name" {
  value = module.gke.gke_cluster_name
}

output "gke_cluster_endpoint" {
  value     = module.gke.gke_cluster_endpoint
  sensitive = true
}
