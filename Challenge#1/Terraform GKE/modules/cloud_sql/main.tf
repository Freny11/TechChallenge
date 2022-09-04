resource "google_sql_database_instance" "postgres" {
  name             = var.db_instance_name
  database_version = "POSTGRES_13"
  region           = var.project_region
  project          = var.project_id
  settings {
    # Second-generation instance tiers are based on the machine
    tier = var.machine_type
    ip_configuration {
      //ipv4_enabled = "true"
      require_ssl = "true"
    }
    backup_configuration {
      enabled                        = "true"
      point_in_time_recovery_enabled = "true"
    }
    availability_type = "ZONAL"
    disk_size         = var.disk_size
  }
}

resource "google_sql_user" "users" {
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.postgres.name
  password = var.user_pass
}

resource "google_sql_database" "database" {
  name     = var.db_name_default
  project  = var.project_id
  instance = google_sql_database_instance.postgres.name
  lifecycle {
    ignore_changes = all
  }
}

#   project  = var.project_id
#   instance = google_sql_database_instance.postgres_prod.0.name
# }
