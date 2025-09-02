resource "google_cloud_run_domain_mapping" "pocketbase" {
  count    = var.enable_cloudflare_dns && var.pb_base_domain != "" ? 1 : 0
  location = var.region
  name     = var.pb_auth_subdomain != "" ? "${var.pb_auth_subdomain}.${var.pb_base_domain}" : var.pb_base_domain
  metadata { namespace = var.project_id }
  spec { route_name = google_cloud_run_v2_service.pocketbase.name }
}

# Cloudflare DNS records (CNAME -> ghs.googlehosted.com)
resource "cloudflare_dns_record" "pocketbase" {
  count      = var.enable_cloudflare_dns && var.pb_base_domain != "" ? 1 : 0
  zone_id    = var.cloudflare_zone_id
  name       = var.pb_auth_subdomain != "" ? "${var.pb_auth_subdomain}.${var.pb_base_domain}" : var.pb_base_domain
  content    = "ghs.googlehosted.com"
  type       = "CNAME"
  proxied    = false
  ttl        = 1
  comment    = "Managed by Terraform - PocketBase endpoint for ${local.pb_base_name}"
  depends_on = [google_cloud_run_domain_mapping.pocketbase]
}
