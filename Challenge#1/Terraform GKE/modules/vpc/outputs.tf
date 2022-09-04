output "vpc_name" {
  value       = google_compute_network.vpc_network.name
  description = "The name of the Auto Scaling Group"
}

output "vpc_subnet_name" {
  value       = var.project_zone
  description = "The name of the Auto Scaling Group"
}
