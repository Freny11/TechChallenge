output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "gke_cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "instance_group_urls" {
  description = "The resource URLs of the managed instance groups associated with this node pool."
  value       = google_container_node_pool.new_application_pool.instance_group_urls
}
