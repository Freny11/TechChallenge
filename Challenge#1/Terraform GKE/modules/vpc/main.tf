resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

resource "google_compute_subnetwork" "discovery" {
  name          = var.project_zone
  ip_cidr_range = "10.132.0.0/20"
  region        = "europe-west4"
  network       = google_compute_network.vpc_network.self_link
  project       = var.project_id

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "allow-internal" {
  name    = "data-discovery-fw-allow-internal"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    "10.128.0.0/20", "10.132.0.0/20", "10.138.0.0/20", "10.140.0.0/20"
  ]
}


# Allow traffic for GCP healthchecks
resource "google_compute_firewall" "allow-l7-traffic" {
  name    = "data-discovery-fw-allow-l7-traffic"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["32000", "32443", "31570"]
  }

  source_ranges = [
    "130.211.0.0/22", "35.191.0.0/16"
  ]
}

