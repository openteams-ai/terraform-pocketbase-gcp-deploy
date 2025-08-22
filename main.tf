locals {
  common_labels = var.labels
}

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

    # TODO: rm after testing
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
      env {
        name  = "ADMIN_EMAIL"
        value = var.admin_email
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

      env {
        name  = "PUBLIC_URL"
        value = var.base_domain != "" ? "https://${local.public_domain}" : "http://localhost:8080"
      }

      # Primary object storage config (S3-compatible / GCS via HMAC)
      env {
        name  = "S3_ENABLED"
        value = tostring(var.s3_enabled)
      }
      env {
        name  = "S3_BUCKET"
        value = local.pb_s3_bucket_name
      }
      env {
        name  = "S3_REGION"
        value = var.s3_region
      }
      env {
        name  = "S3_ENDPOINT"
        value = var.s3_endpoint
      }
      env {
        name  = "S3_ACCESS_KEY"
        value = var.s3_access_key
      }
      env {
        name  = "S3_SECRET"
        value = var.s3_secret
      }
      env {
        name  = "S3_FORCE_PATH_STYLE"
        value = tostring(var.s3_force_path_style)
      }

      # Optional backups bucket (may be same as primary)
      env {
        name  = "BACKUPS_S3_ENABLED"
        value = tostring(var.backups_s3_enabled)
      }
      env {
        name  = "BACKUPS_S3_BUCKET"
        value = local.pb_backups_bucket_name
      }
      env {
        name  = "BACKUPS_CRON"
        value = var.backups_cron
      }
      env {
        name  = "BACKUPS_CRON_MAX_KEEP"
        value = var.backups_cron_max_keep
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
    }

  }
  labels = local.common_labels

  depends_on = [
    google_project_service.required_apis,
  ]
}
