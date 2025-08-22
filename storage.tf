# create if user did not supply s3_bucket
resource "google_storage_bucket" "pb_s3_bucket" {
  count    = var.s3_bucket == "" ? 1 : 0
  name     = "${var.name_prefix}-pb-s3"
  project  = var.project_id
  location = var.region
  labels   = merge(var.labels, { component = "pocketbase", purpose = "primary-storage" })
}

data "google_storage_bucket" "pb_s3_bucket" {
  count   = var.s3_bucket != "" ? 1 : 0
  name    = var.s3_bucket
  project = var.project_id
}

# Backups bucket (only when backups enabled)
resource "google_storage_bucket" "pb_backups_bucket" {
  count    = var.backups_s3_enabled && var.backups_s3_bucket == "" ? 1 : 0
  name     = "${var.name_prefix}-pb-backups"
  project  = var.project_id
  location = var.region
  labels   = merge(var.labels, { component = "pocketbase", purpose = "backups" })
}

data "google_storage_bucket" "pb_backups_bucket" {
  count   = var.backups_s3_enabled && var.backups_s3_bucket != "" ? 1 : 0
  name    = var.backups_s3_bucket
  project = var.project_id
}
