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

// PocketBase container
variable "pocketbase_image" {
  description = "Container image reference for PocketBase (supports Litestream if baked-in)"
  type        = string
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

variable "admin_email" {
  description = "Initial PocketBase admin email to bootstrap (used only on first deploy if container entrypoint supports it)"
  type        = string
  default     = "admin@example.com"
}

// S3 storage settings for PocketBase file storage (used when S3_ENABLED=true)
variable "s3_enabled" {
  description = "Enable S3-compatible (or GCS via S3 API) storage for PocketBase (docker-compose default false)"
  type        = bool
  default     = false
}

variable "s3_bucket" {
  description = "Primary S3 bucket name for PocketBase file storage"
  type        = string
  default     = ""
  validation {
    condition     = var.s3_bucket == "" || can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.s3_bucket))
    error_message = "s3_bucket must be empty or a valid bucket name (3-63 chars, lowercase, digits, dash, dot, underscore)."
  }
}

variable "s3_region" {
  description = "Region for S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "s3_endpoint" {
  description = "Custom S3 endpoint (leave empty for AWS). Useful for MinIO or R2."
  type        = string
  default     = ""
}

variable "s3_access_key" {
  description = "S3 access key (consider using a secret manager in production)"
  type        = string
  default     = ""
}

variable "s3_secret" {
  description = "S3 secret key (consider using a secret manager in production)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "s3_force_path_style" {
  description = "Force path-style addressing for S3 (compose default true)"
  type        = bool
  default     = true
}

// Backup configuration (object storage copy via container cron/logic)
variable "backups_s3_enabled" {
  description = "Enable periodic PocketBase backup uploads to object storage"
  type        = bool
  default     = false
}

variable "backups_s3_bucket" {
  description = "Bucket for PocketBase backups (can be same as s3_bucket)"
  type        = string
  default     = ""
  validation {
    condition     = var.backups_s3_bucket == "" || can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.backups_s3_bucket))
    error_message = "backups_s3_bucket must be empty or a valid bucket name."
  }
}

variable "backups_cron" {
  description = "Cron expression for backups (leave empty to disable schedule if backups enabled; compose had no default)"
  type        = string
  default     = ""
}

variable "backups_cron_max_keep" {
  description = "Max number of backup archives to retain (compose default 5)"
  type        = string
  default     = "5"
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

variable "deployment_env" {
  description = "Logical deployment environment identifier (e.g. local, staging, prod) exposed as DEPLOYMENT_ENV"
  type        = string
  default     = "local"
}

# variable "gcp_application_credentials_b64" {
#   description = "Optional base64 encoded GCP service account JSON (for Litestream or S3-compatible access) exposed as GCP_APPLICATION_CREDENTIALS_B64 when non-empty"
#   type        = string
#   default     = ""
#   sensitive   = true
# }


// DNS / Cloudflare
variable "enable_cloudflare_dns" {
  description = "Whether to create Cloudflare DNS records for PocketBase and frontend"
  type        = bool
  default     = false
}


variable "pb_auth_subdomain" {
  description = "Subdomain for PocketBase service (auth.example.com)"
  type        = string
  default     = "auth"
}

variable "pb_base_domain" {
  description = "Domain for PocketBase service (e.g. pb.example.com)"
  type        = string
  default     = ""
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the base domain"
  type        = string
  default     = ""
}
