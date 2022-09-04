module "monitoring_service_account" {
  source       = "./modules/service-account"
  account_id   = "data-discovery-cluster-service"
  display_name = "data-discovery-cluster-service"
  description  = "service account used by Application monitoring stack"
  project_id   = var.project_id
}

module "gcp_vpc" {
  source          = "./modules/vpc"
  vpc_name        = "vpc-data-${var.environment}"
  vpc_subnet_name = var.project_zone
  environment     = var.environment
  project_id      = var.project_id
  project_region  = var.project_region
  project_zone    = var.project_zone
}


module "gke" {
  source                   = "./modules/gke"
  project_id               = var.project_id
  gke_cluster_location     = var.project_region
  gke_cluster_name         = "data-${var.environment}"
  gke_cluster_network_name = module.gcp_vpc.vpc_name
  gke_cluster_subnetwork   = module.gcp_vpc.vpc_subnet_name
  # New Application node pool spec
  gke_cluster_new_node_pool_name        = "data-discovery-pool"
  preemptible                           = var.preemptible
  gke_cluster_new_node_pool_scopes      = ["https://www.googleapis.com/auth/cloud-platform"]
  gke_cluster_new_node_pool_size        = 2
  application_pool_service_account      = module.monitoring_service_account.service_account_email
  gke_cluster_new_node_pool_machine_tpe = "n1-standard-8"
  gke_cluster_new_node_pool_min_count   = 2
  gke_cluster_new_node_pool_max_count   = 6
  namespaces = [
    "data-discovery",
    "nginx"
  ]

  depends_on = [
    module.gcp_vpc
  ]
}

module "cloud_sql" {
  source           = "./modules/cloud_sql"
  region           = var.project_region
  project          = var.project_id
  zone             = var.project_zone
  db_instance_name = var.SQL_INSTANCE_NAME
  machine_type     = "db-custom-4-25600" // vCPU=10, Mem in MB 51200
  disk_size        = "100"               // disk size in GB
  db_name          = var.DB_NAME
  user_name        = var.DB_USER
  user_pass        = var.DB_PASS
  project_id       = var.project_id
  project_region   = var.project_region
  db_name_default  = var.SQL_DEFAULT_DB_NAME
  environment      = var.environment
}

