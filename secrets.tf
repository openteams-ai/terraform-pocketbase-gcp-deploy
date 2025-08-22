resource "google_secret_manager_secret" "pb_encryption_key" {
  secret_id = "${var.name_prefix}-pb-encryption-key"
  project   = var.project_id
  replication {
    auto {}
  }
  labels = merge(var.labels, {
    component = "pocketbase"
    purpose   = "encryption-key"
  })
}

resource "google_secret_manager_secret_version" "pb_encryption_key_v1" {
  secret      = google_secret_manager_secret.pb_encryption_key.id
  secret_data = random_bytes.pb_encryption_key.base64
}

# Admin password secret (bootstrap only)
resource "google_secret_manager_secret" "pb_admin_password" {
  secret_id = "${var.name_prefix}-pb-admin-password"
  project   = var.project_id
  replication {
    auto {}
  }
  labels = merge(var.labels, {
    component = "pocketbase"
    purpose   = "admin-password"
  })
}

resource "google_secret_manager_secret_version" "pb_admin_password_v1" {
  secret      = google_secret_manager_secret.pb_admin_password.id
  secret_data = random_password.pb_admin_password.result
}
