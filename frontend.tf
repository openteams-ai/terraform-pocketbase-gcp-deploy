resource "google_cloud_run_v2_service" "frontend" {
  count    = var.enable_frontend_service && var.frontend_image != null ? 1 : 0
  name     = local.fe_base_name
  location = var.region
  template {
    containers {
      image = var.frontend_image
      env {
        name  = "VITE_API_ORIGIN"
        value = "https://${local.auth_domain}" // API removed; referencing auth domain for possible direct calls
      }
      env {
        name  = "VITE_AUTH_ORIGIN"
        value = "https://${local.auth_domain}"
      }
      dynamic "env" {
        for_each = var.frontend_additional_env
        content {
          name  = env.key
          value = env.value
        }
      }
      ports {
        container_port = 80
      }
    }
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
  labels = var.labels
}
