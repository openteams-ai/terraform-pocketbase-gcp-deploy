
resource "random_bytes" "pb_encryption_key" {
  length = 32
}

resource "random_password" "pb_admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}


resource "google_cloud_run_v2_service" "pocketbase" {
  name     = local.pb_base_name
  location = var.region
  project  = var.project_id

  deletion_protection = false

  template {
    service_account = google_service_account.pb.email
    scaling {
      max_instance_count = 1
      min_instance_count = 1
    }

    volumes {
      name = "pb_db"
      empty_dir {
        medium = "MEMORY"
      }

    }

    containers {
      image = var.pocketbase_image
      resources {
        limits = {
          cpu    = tostring(var.pocketbase_resources.cpu)
          memory = tostring(var.pocketbase_resources.memory)
        }
      }
      startup_probe {
        initial_delay_seconds = 10
        timeout_seconds       = 5
        period_seconds        = 3
        failure_threshold     = 1
        tcp_socket {
          port = 8080
        }
      }
      # https://github.com/pocketbase/pocketbase/blob/master/apis/health.go
      liveness_probe {
        http_get {
          path = "/api/health"
        }
      }
      # Refer to Secret Manager for encryption key
      env {
        name = "PB_ENCRYPTION_KEY"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.pb_encryption_key.secret_id
            version = "latest"
          }
        }
      }
      # Refer to Secret Manager for admin password
      env {
        name = "ADMIN_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.pb_admin_password.secret_id
            version = "latest"
          }
        }
      }

      # Dynamically render all non-secret environment variables from merged map
      dynamic "env" {
        for_each = local.pb_env
        content {
          name  = env.key
          value = env.value
        }
      }
      ports {
        container_port = 8080
      }
    }

  }
  labels = var.labels

  depends_on = [
    google_project_service.required_apis,
  ]
}
