resource "google_service_account" "pb" {
  account_id   = replace("${local.pb_base_name}-sa", "_", "-")
  display_name = "PocketBase Service Account"
  project      = var.project_id
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",           # Cloud Run
    "secretmanager.googleapis.com", # Secret Manager
    # "compute.googleapis.com",              # Compute Engine (for VPC)
    "iam.googleapis.com",                  # Identity and Access Management
    "cloudresourcemanager.googleapis.com", # Cloud Resource Manager
    "storage.googleapis.com"               # Cloud Storage
  ])

  project = var.project_id
  service = each.key

  disable_dependent_services = false
  disable_on_destroy         = false

  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource "google_storage_bucket_iam_member" "pb_s3_bucket_admin" {
  count  = var.s3_bucket == "" ? 1 : 0
  bucket = google_storage_bucket.pb_s3_bucket[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_storage_bucket_iam_member" "pb_s3_bucket_admin_existing" {
  count  = var.s3_bucket != "" ? 1 : 0
  bucket = data.google_storage_bucket.pb_s3_bucket[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_storage_bucket_iam_member" "pb_backups_bucket_admin" {
  count  = var.backups_s3_enabled && var.backups_s3_bucket == "" ? 1 : 0
  bucket = google_storage_bucket.pb_backups_bucket[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_storage_bucket_iam_member" "pb_backups_bucket_admin_existing" {
  count  = var.backups_s3_enabled && var.backups_s3_bucket != "" ? 1 : 0
  bucket = data.google_storage_bucket.pb_backups_bucket[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_cloud_run_v2_service_iam_member" "pb_invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  name     = google_cloud_run_v2_service.pocketbase.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Secret access for PocketBase Cloud Run service account
resource "google_secret_manager_secret_iam_member" "pb_encryption_key_access" {
  secret_id = google_secret_manager_secret.pb_encryption_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_secret_manager_secret_iam_member" "pb_admin_password_access" {
  secret_id = google_secret_manager_secret.pb_admin_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.pb.email}"
}

# resource "google_cloud_run_v2_service_iam_member" "frontend_invoker" {
#   count    = (var.allow_unauthenticated && var.enable_frontend_service && var.frontend_image != null) ? 1 : 0
#   name     = try(google_cloud_run_v2_service.frontend[0].name, null)
#   location = var.region
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }
