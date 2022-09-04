resource "google_sql_database_instance" "postgres" {
  count            = var.environment == "prod" ? 0 : 1
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
  count    = var.environment == "prod" ? 0 : 1
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.postgres.0.name
  password = var.user_pass
}

resource "google_sql_database" "database" {
  count    = var.environment == "prod" ? 0 : 1
  name     = var.db_name_default
  project  = var.project_id
  instance = google_sql_database_instance.postgres.0.name
  lifecycle {
    ignore_changes = all
  }
}

resource "google_sql_database" "database2" {
  count    = var.environment == "prod" ? 0 : 1
  name     = var.db_name
  project  = var.project_id
  instance = google_sql_database_instance.postgres.0.name
}

# TODO: Enable for PROD
# resource "google_sql_database_instance" "postgres_prod" {
#   count            = var.environment == "prod" ? 1 : 0
#   name             = var.db_instance_name
#   database_version = "POSTGRES_13"
#   region           = var.project_region
#   project          = var.project_id
#   settings {
#     # Second-generation instance tiers are based on the machine
#     tier = var.machine_type
#     ip_configuration {
#       //ipv4_enabled = "true"
#       require_ssl = "true"
#     }
#     backup_configuration {
#       enabled                        = "true"
#       point_in_time_recovery_enabled = "true"
#     }
#     availability_type = "REGIONAL"
#     disk_size         = var.disk_size
#   }
# }

# TODO: Enable for PROD
# resource "google_sql_user" "users_prod" {
#   count    = var.environment == "prod" ? 1 : 0
#   name     = var.user_name
#   project  = var.project_id
#   instance = google_sql_database_instance.postgres_prod.0.name
#   password = var.user_pass
# }

# resource "google_sql_database" "database_prod" {
#   count    = var.environment == "prod" ? 1 : 0
#   name     = var.db_name_default
#   project  = var.project_id
#   instance = google_sql_database_instance.postgres_prod.0.name
#   lifecycle {
#     ignore_changes = all
#   }
# }

# resource "google_sql_database" "database2_prod" {
#   count    = var.environment == "prod" ? 1 : 0
#   name     = var.db_name
#   project  = var.project_id
#   instance = google_sql_database_instance.postgres_prod.0.name
# }
