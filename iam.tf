resource "google_service_account" "pb" {
  account_id   = replace("${local.pb_base_name}-sa", "_", "-")
  display_name = "PocketBase Service Account"
}

resource "google_project_iam_member" "pb_storage_admin_fuse" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.pb.email}"
}

resource "google_cloud_run_v2_service_iam_member" "pb_invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  name     = google_cloud_run_v2_service.pocketbase.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "frontend_invoker" {
  count    = (var.allow_unauthenticated && var.enable_frontend_service && var.frontend_image != null) ? 1 : 0
  name     = try(google_cloud_run_v2_service.frontend[0].name, null)
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
