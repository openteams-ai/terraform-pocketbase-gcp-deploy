// DNS and domain mapping (Cloudflare + Cloud Run domain mappings)

# Cloud Run domain mappings (PocketBase & Frontend) - require manual DNS CNAME to ghs.googlehosted.com first
resource "google_cloud_run_domain_mapping" "pocketbase" {
  count    = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  location = var.region
  name     = local.auth_domain
  metadata { namespace = var.project_id }
  spec {
    route_name = google_cloud_run_v2_service.pocketbase.name
  }
}

resource "google_cloud_run_domain_mapping" "frontend" {
  count    = var.enable_cloudflare_dns && var.enable_frontend_service && var.frontend_image != null && var.base_domain != "" ? 1 : 0
  location = var.region
  name     = local.frontend_domain
  metadata { namespace = var.project_id }
  spec { route_name = try(google_cloud_run_v2_service.frontend[0].name, null) }
}

# Cloudflare DNS records (CNAME -> ghs.googlehosted.com)
resource "cloudflare_record" "pocketbase" {
  count   = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.auth_subdomain
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false
  comment = "Managed by Terraform - PocketBase endpoint for ${local.resource_prefix}"

  depends_on = [google_cloud_run_domain_mapping.pocketbase]
}

resource "cloudflare_record" "frontend" {
  count   = var.enable_cloudflare_dns && var.base_domain != "" ? 1 : 0
  zone_id = var.cloudflare_zone_id
  name    = var.app_subdomain
  content = "ghs.googlehosted.com"
  type    = "CNAME"
  proxied = false
  comment = "Managed by Terraform - Frontend endpoint for ${local.resource_prefix}"

  depends_on = [google_cloud_run_domain_mapping.frontend]
}
