// Core settings
variable "project_id" {
  description = "GCP project ID where resources will be deployed"
  type        = string
}

variable "region" {
  description = "Primary region for Cloud Run services and buckets"
  type        = string
  default     = "us-central1"
}

variable "name_prefix" {
  description = "Prefix used for naming resources (e.g. myapp-dev)"
  type        = string
}


variable "labels" {
  description = "Optional map of labels applied to supported resources"
  type        = map(string)
  default     = {}
}

// PocketBase container & mode
variable "pocketbase_image" {
  description = "Container image reference for PocketBase (supports Litestream if baked-in)"
  type        = string
}


variable "pocketbase_min_instances" {
  description = "Minimum Cloud Run instances for PocketBase (keep warm)"
  type        = number
  default     = 0
}

variable "pocketbase_resources" {
  description = "Resource settings for the PocketBase Cloud Run container (cpu as number, memory as string like 512Mi / 1Gi)"
  type = object({
    cpu    = number
    memory = string
  })
  default = {
    cpu    = 1
    memory = "512Mi"
  }
}

variable "cookie_domain" {
  description = "Domain used for cross-service auth cookies (e.g. .example.com)"
  type        = string
}

variable "base_domain" {
  description = "Base apex/root domain (example.com) for constructing service URLs"
  type        = string
}

variable "auth_subdomain" {
  description = "Subdomain for PocketBase service (auth.example.com)"
  type        = string
  default     = "auth"
}

variable "litestream_replica_url" {
  description = "Replica destination URL for Litestream (e.g. s3://bucket/path). Container must know how to auth. Null to disable injection."
  type        = string
  default     = null
}

variable "litestream_restore" {
  description = "Whether to run a Litestream restore on first start (container entrypoint must implement logic)."
  type        = bool
  default     = false
}

variable "litestream_db_path" {
  description = "Path to the PocketBase SQLite database file used by Litestream (inside container)."
  type        = string
  default     = "/pb/pb_data/data.db"
}

// Frontend service configuration
variable "frontend_image" {
  description = "Container image for Nginx SPA"
  type        = string
  default     = null
}

variable "enable_frontend_service" {
  description = "Deploy frontend Cloud Run service when true and frontend_image provided"
  type        = bool
  default     = false
}

variable "frontend_subdomain" {
  description = "Subdomain for frontend (app.example.com)"
  type        = string
  default     = "app"
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated invocation of services (public access)"
  type        = bool
  default     = true
}

variable "additional_env" {
  description = "Additional environment variables applied to PocketBase container"
  type        = map(string)
  default     = {}
}

variable "frontend_additional_env" {
  description = "Additional env vars for frontend service"
  type        = map(string)
  default     = {}
}

// DNS / Cloudflare
variable "enable_cloudflare_dns" {
  description = "Whether to create Cloudflare DNS records for PocketBase and frontend"
  type        = bool
  default     = false
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the base domain"
  type        = string
  default     = ""
}

variable "app_subdomain" {
  description = "Alias for frontend subdomain (if separate) used in DNS records"
  type        = string
  default     = "app"
}
