// Local values centralizing naming & domains
locals {
  pb_base_name = "${var.name_prefix}-pb"
  # fe_base_name = "${var.name_prefix}-web"

  auth_domain     = "${var.auth_subdomain}.${var.base_domain}"
  frontend_domain = "${var.frontend_subdomain}.${var.base_domain}"

  public_domain = local.auth_domain

  pb_s3_bucket_name = var.s3_bucket != "" ? var.s3_bucket : google_storage_bucket.pb_s3_bucket[0].name
  pb_backups_bucket_name = var.backups_s3_bucket != "" ? var.backups_s3_bucket : (
    var.backups_s3_enabled && length(google_storage_bucket.pb_backups_bucket) > 0 ? google_storage_bucket.pb_backups_bucket[0].name : local.pb_s3_bucket_name
  )

  # resource_prefix = var.name_prefix
}
