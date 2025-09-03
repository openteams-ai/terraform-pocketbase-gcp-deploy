locals {
  pb_base_name   = "${var.name_prefix}-pb"
  pocketbase_url = var.pb_base_domain != "" && var.pb_auth_subdomain != "" ? "https://${var.pb_auth_subdomain}.${var.pb_base_domain}" : "http://localhost:8080"

  pb_s3_bucket_name = var.s3_bucket != "" ? var.s3_bucket : google_storage_bucket.pb_s3_bucket[0].name
  pb_backups_bucket_name = var.backups_s3_bucket != "" ? var.backups_s3_bucket : (
    var.backups_s3_enabled && length(google_storage_bucket.pb_backups_bucket) > 0 ? google_storage_bucket.pb_backups_bucket[0].name : local.pb_s3_bucket_name
  )

  // Base env map (excluding secrets handled with value_source)
  pb_base_env = {
    ADMIN_EMAIL           = var.admin_email
    DEPLOYMENT_ENV        = var.deployment_env
    LITESTREAM_ENABLED    = "true"
    LITESTREAM_GCS_BUCKET = google_storage_bucket.pb_litestream_bucket.name
    LITESTREAM_GCS_PATH   = "pocketbase/data.db"
    POCKETBASE_URL        = local.pocketbase_url
    COOKIE_DOMAIN         = var.cookie_domain
  }

  pb_env = merge(
    local.pb_base_env,
    var.s3_enabled ? {
      S3_ENABLED          = tostring(var.s3_enabled)
      S3_BUCKET           = local.pb_s3_bucket_name
      S3_REGION           = var.s3_region
      S3_ENDPOINT         = var.s3_endpoint
      S3_ACCESS_KEY       = var.s3_access_key
      S3_SECRET           = var.s3_secret
      S3_FORCE_PATH_STYLE = tostring(var.s3_force_path_style)
    } : {},
    var.backups_s3_enabled ? {
      BACKUPS_S3_ENABLED    = tostring(var.backups_s3_enabled)
      BACKUPS_S3_BUCKET     = local.pb_backups_bucket_name
      BACKUPS_CRON          = var.backups_cron
      BACKUPS_CRON_MAX_KEEP = var.backups_cron_max_keep
    } : {},
    var.additional_env
  )
}
