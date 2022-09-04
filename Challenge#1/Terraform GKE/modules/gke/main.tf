resource "google_container_cluster" "primary" {
  name                        = var.gke_cluster_name
  project                     = var.project_id
  location                    = var.gke_cluster_location
  remove_default_node_pool    = true
  initial_node_count          = 1
  min_master_version          = "1.21.12-gke.1700"
  network                     = var.gke_cluster_network_name
  subnetwork                  = var.gke_cluster_subnetwork
  enable_shielded_nodes       = true
  enable_binary_authorization = true

  release_channel {
    channel = "UNSPECIFIED"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "new_application_pool" {
  name     = var.gke_cluster_new_node_pool_name
  project  = var.project_id
  location = var.gke_cluster_location
  cluster  = google_container_cluster.primary.name
  version            = "1.21.12-gke.1700"
  initial_node_count = var.gke_cluster_new_node_pool_size
  node_config {
    preemptible     = var.preemptible
    service_account = var.application_pool_service_account
    machine_type    = var.gke_cluster_new_node_pool_machine_tpe
    metadata = {
      disable-legacy-endpoints = "true"
    }
    labels = {
      category = "app"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    oauth_scopes = var.gke_cluster_new_node_pool_scopes
  }
  autoscaling {
    min_node_count = var.gke_cluster_new_node_pool_min_count
    max_node_count = var.gke_cluster_new_node_pool_max_count
  }
  management {
    auto_upgrade = false
    auto_repair  = true
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "nginx-ingress"
  repository = "https://charts.helm.sh/stable"
  namespace  = "nginx"

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }


  set {
    name  = "controller.image.tag"
    value = "v1.1.1"
  }


  set {
    name  = "controller.service.nodePorts.http"
    value = 32000
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = 32443
  }

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    type  = "string"
    name  = "controller.config.server-tokens"
    value = false
  }

}

resource "null_resource" "ingress-named-ports-https" {
  provisioner "local-exec" {
    command = <<EOT
           for i in ${join(" ", google_container_node_pool.new_application_pool.instance_group_urls)}
           do
               gcloud --project ${var.project_id} compute instance-groups set-named-ports $(gcloud --project ${var.project_id} compute instance-groups managed list --format json | jq -r '.[] | select(.selfLink == "'$i'") | .instanceGroup') --named-ports=nginx-ingress-https:32443,istio-ad-ingress-gateway:31570
           done
       EOT
  }
  depends_on = [
  helm_release.nginx_ingress]
}

resource "kubernetes_namespace" "istio_namespace" {
  for_each = var.istio ? var.namespaces : []
  metadata {
    name = each.value
    labels = {
      istio-injection = "enabled"
    }
  }
  depends_on = [google_container_cluster.primary]
}
