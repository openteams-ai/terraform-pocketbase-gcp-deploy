output "pocketbase_url" {
  description = "Deployed PocketBase service base URL"
  value       = google_cloud_run_v2_service.pocketbase.uri
}

output "pocketbase_service_account" {
  description = "Service account email used by PocketBase"
  value       = google_service_account.pb.email
}

output "storage_primary_bucket" {
  description = "Effective primary object storage bucket name"
  value       = local.pb_s3_bucket_name
}

output "storage_backups_bucket" {
  description = "Effective backups bucket name (may equal primary)"
  value       = local.pb_backups_bucket_name
}

# output "frontend_url" {
#   description = "Frontend service URL (null if disabled)"
#   value       = try(google_cloud_run_v2_service.frontend[0].uri, null)
# }

output "auth_domain" {
  description = "Auth (PocketBase) domain constructed from subdomain + base domain"
  value       = "${var.auth_subdomain}.${var.base_domain}"
}

output "pocketbase_custom_domain" {
  description = "Custom domain mapped to the PocketBase service (if enabled)."
  value       = var.enable_cloudflare_dns && var.base_domain != "" ? local.auth_domain : null
}

output "frontend_custom_domain" {
  description = "Custom domain mapped to the Frontend service (if enabled)."
  value       = var.enable_cloudflare_dns && var.enable_frontend_service && var.base_domain != "" ? local.frontend_domain : null
}

output "cloudflare_pocketbase_record" {
  description = "Cloudflare record (subdomain) created for PocketBase (if enabled)."
  value       = var.enable_cloudflare_dns && var.base_domain != "" ? var.auth_subdomain : null
}

output "cloudflare_frontend_record" {
  description = "Cloudflare record (subdomain) created for Frontend (if enabled)."
  value       = var.enable_cloudflare_dns && var.enable_frontend_service && var.base_domain != "" ? var.app_subdomain : null
}

output "pb_admin_password" {
  description = "Bootstrap admin password (also stored in Secret Manager; rotate after first login)"
  value       = random_password.pb_admin_password.result
  sensitive   = true
}
