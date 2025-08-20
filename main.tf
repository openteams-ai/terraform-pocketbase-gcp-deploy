resource "google_cloud_run_v2_service" "pocketbase" {
  name     = local.pb_base_name
  location = var.region

  template {
    service_account = google_service_account.pb.email
    scaling {
      max_instance_count = 1
      min_instance_count = var.pocketbase_min_instances
    }
    containers {
      image = var.pocketbase_image
      resources {
        limits = {
          cpu    = tostring(var.pocketbase_resources.cpu)
          memory = var.pocketbase_resources.memory
        }
      }
      env {
        name  = "COOKIE_DOMAIN"
        value = var.cookie_domain
      }
      env {
        name  = "BASE_DOMAIN"
        value = var.base_domain
      }
      env {
        name  = "AUTH_ORIGIN"
        value = "https://${local.auth_domain}"
      }
      dynamic "env" {
        for_each = var.additional_env
        content {
          name  = env.key
          value = env.value
        }
      }
      ports {
        container_port = 8080
      }
      dynamic "env" {
        for_each = var.litestream_replica_url != null ? ["replica"] : []
        content {
          name  = "LITESTREAM_REPLICA_URL"
          value = var.litestream_replica_url
        }
      }
      dynamic "env" {
        for_each = var.litestream_restore ? ["restore"] : []
        content {
          name  = "LITESTREAM_RESTORE"
          value = "true"
        }
      }
      env {
        name  = "LITESTREAM_DB_PATH"
        value = var.litestream_db_path
      }
    }
  }
  ingress = "INGRESS_TRAFFIC_ALL"
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  labels = var.labels
}
