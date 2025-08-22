# PocketBase on GCP (Cloud Run + GCS FUSE) Terraform Module

Deploy a PocketBase instance to Google Cloud Run using a persistent GCS bucket mounted via Cloud Storage FUSE for `pb_data`, with an optional frontend service and optional Cloudflare-managed custom domains.

## Features

- 🚀 PocketBase served via Cloud Run (v2)
- 💾 Persistent storage using a GCS bucket (mounted with Cloud Storage FUSE)
- 🌐 Optional frontend (e.g. login UI / SPA) Cloud Run service
- 🔐 Optional unauthenticated or restricted access toggle
- 🌀 Optional Cloudflare DNS CNAME records + Cloud Run domain mappings
- � Simple environment variable injection for services
- � Minimal attack surface (Litestream, backups, extra buckets removed in this variant)

## Quick Start

1. Add this module to your configuration
2. Provide PocketBase image (built with any required plugins)
3. (Optional) Provide frontend container image
4. (Optional) Enable Cloudflare DNS + supply zone ID and base domain
5. Apply and retrieve output service URLs

## Architecture Overview

PocketBase runs as a single Cloud Run service backed by a GCS bucket mounted using FUSE. Writes go directly to the mounted bucket. A lightweight optional frontend service can be deployed (e.g. SPA or auth UI). If Cloudflare DNS is enabled, the module provisions Cloud Run domain mappings and Cloudflare CNAME records (`auth.<base_domain>`, `app.<base_domain>` by default) pointing to `ghs.googlehosted.com`.

## Module Documentation

The following section contains auto-generated documentation (terraform-docs):

<!-- BEGIN_TF_DOCS -->


## Usage

```hcl
module "pocketbase_stack" {
  source  = "github.com/openteams-ai/terraform-pocketbase-gcp-deploy"

  project_id    = "my-gcp-project"
  region        = "us-central1"
  name_prefix   = "myapp-dev"
  base_domain   = "example.com"
  cookie_domain = ".example.com"
pocketbase_image     = "us-docker.pkg.dev/myproj/images/pocketbase:fuse"
enable_frontend_service = true
frontend_image          = "us-docker.pkg.dev/myproj/images/web:latest"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.7 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.49.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.49.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_domain_mapping.pocketbase](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_v2_service.pocketbase](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service_iam_member.pb_invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_member) | resource |
| [google_project_service.required_apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.pb_admin_password](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.pb_encryption_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.pb_admin_password_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_iam_member.pb_encryption_key_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.pb_admin_password_v1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.pb_encryption_key_v1](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.pb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.pb_backups_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.pb_s3_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.pb_backups_bucket_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.pb_backups_bucket_admin_existing](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.pb_s3_bucket_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.pb_s3_bucket_admin_existing](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_bytes.pb_encryption_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |
| [random_password.pb_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [google_storage_bucket.pb_backups_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket) | data source |
| [google_storage_bucket.pb_s3_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_env"></a> [additional\_env](#input\_additional\_env) | Additional environment variables applied to PocketBase container | `map(string)` | `{}` | no |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Initial PocketBase admin email to bootstrap (used only on first deploy if container entrypoint supports it) | `string` | `"admin@example.com"` | no |
| <a name="input_allow_unauthenticated"></a> [allow\_unauthenticated](#input\_allow\_unauthenticated) | Allow unauthenticated invocation of services (public access) | `bool` | `true` | no |
| <a name="input_app_subdomain"></a> [app\_subdomain](#input\_app\_subdomain) | Alias for frontend subdomain (if separate) used in DNS records | `string` | `"app"` | no |
| <a name="input_auth_subdomain"></a> [auth\_subdomain](#input\_auth\_subdomain) | Subdomain for PocketBase service (auth.example.com) | `string` | `"auth"` | no |
| <a name="input_backups_cron"></a> [backups\_cron](#input\_backups\_cron) | Cron expression for backups (leave empty to disable schedule if backups enabled; compose had no default) | `string` | `""` | no |
| <a name="input_backups_cron_max_keep"></a> [backups\_cron\_max\_keep](#input\_backups\_cron\_max\_keep) | Max number of backup archives to retain (compose default 5) | `string` | `"5"` | no |
| <a name="input_backups_s3_bucket"></a> [backups\_s3\_bucket](#input\_backups\_s3\_bucket) | Bucket for PocketBase backups (can be same as s3\_bucket) | `string` | `""` | no |
| <a name="input_backups_s3_enabled"></a> [backups\_s3\_enabled](#input\_backups\_s3\_enabled) | Enable periodic PocketBase backup uploads to object storage | `bool` | `false` | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base apex/root domain (example.com) for constructing service URLs; empty to use internal/local URL | `string` | `""` | no |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Whether to create Cloudflare DNS records for PocketBase and frontend | `bool` | `false` | no |
| <a name="input_enable_frontend_service"></a> [enable\_frontend\_service](#input\_enable\_frontend\_service) | Deploy frontend Cloud Run service when true and frontend\_image provided | `bool` | `false` | no |
| <a name="input_frontend_subdomain"></a> [frontend\_subdomain](#input\_frontend\_subdomain) | Subdomain for frontend (app.example.com) | `string` | `"app"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Optional map of labels applied to supported resources | `map(string)` | `{}` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used for naming resources (e.g. myapp-dev) | `string` | n/a | yes |
| <a name="input_pocketbase_image"></a> [pocketbase\_image](#input\_pocketbase\_image) | Container image reference for PocketBase (supports Litestream if baked-in) | `string` | n/a | yes |
| <a name="input_pocketbase_resources"></a> [pocketbase\_resources](#input\_pocketbase\_resources) | Resource settings for the PocketBase Cloud Run container (cpu as number, memory as string like 512Mi / 1Gi) | <pre>object({<br/>    cpu    = number<br/>    memory = string<br/>  })</pre> | <pre>{<br/>  "cpu": 1,<br/>  "memory": "512Mi"<br/>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Primary region for Cloud Run services and buckets | `string` | `"us-central1"` | no |
| <a name="input_s3_access_key"></a> [s3\_access\_key](#input\_s3\_access\_key) | S3 access key (consider using a secret manager in production) | `string` | `""` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Primary S3 bucket name for PocketBase file storage | `string` | `""` | no |
| <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled) | Enable S3-compatible (or GCS via S3 API) storage for PocketBase (docker-compose default false) | `bool` | `false` | no |
| <a name="input_s3_endpoint"></a> [s3\_endpoint](#input\_s3\_endpoint) | Custom S3 endpoint (leave empty for AWS). Useful for MinIO or R2. | `string` | `""` | no |
| <a name="input_s3_force_path_style"></a> [s3\_force\_path\_style](#input\_s3\_force\_path\_style) | Force path-style addressing for S3 (compose default true) | `bool` | `true` | no |
| <a name="input_s3_region"></a> [s3\_region](#input\_s3\_region) | Region for S3 bucket | `string` | `"us-east-1"` | no |
| <a name="input_s3_secret"></a> [s3\_secret](#input\_s3\_secret) | S3 secret key (consider using a secret manager in production) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_domain"></a> [auth\_domain](#output\_auth\_domain) | Auth (PocketBase) domain constructed from subdomain + base domain |
| <a name="output_cloudflare_frontend_record"></a> [cloudflare\_frontend\_record](#output\_cloudflare\_frontend\_record) | Cloudflare record (subdomain) created for Frontend (if enabled). |
| <a name="output_cloudflare_pocketbase_record"></a> [cloudflare\_pocketbase\_record](#output\_cloudflare\_pocketbase\_record) | Cloudflare record (subdomain) created for PocketBase (if enabled). |
| <a name="output_frontend_custom_domain"></a> [frontend\_custom\_domain](#output\_frontend\_custom\_domain) | Custom domain mapped to the Frontend service (if enabled). |
| <a name="output_pb_admin_password"></a> [pb\_admin\_password](#output\_pb\_admin\_password) | Bootstrap admin password (also stored in Secret Manager; rotate after first login) |
| <a name="output_pocketbase_custom_domain"></a> [pocketbase\_custom\_domain](#output\_pocketbase\_custom\_domain) | Custom domain mapped to the PocketBase service (if enabled). |
| <a name="output_pocketbase_service_account"></a> [pocketbase\_service\_account](#output\_pocketbase\_service\_account) | Service account email used by PocketBase |
| <a name="output_pocketbase_url"></a> [pocketbase\_url](#output\_pocketbase\_url) | Deployed PocketBase service base URL |
| <a name="output_storage_backups_bucket"></a> [storage\_backups\_bucket](#output\_storage\_backups\_bucket) | Effective backups bucket name (may equal primary) |
| <a name="output_storage_primary_bucket"></a> [storage\_primary\_bucket](#output\_storage\_primary\_bucket) | Effective primary object storage bucket name |
<!-- END_TF_DOCS -->

## Documentation Maintenance

Content between the terraform-docs markers is auto-generated. Run:
```
make docs
```
to refresh after changing inputs/outputs.

## Testing

Terratest scaffold is included (validation-focused). Run:
```
make test
```
Enhance tests as you adopt this module.

## Makefile Highlights

Common targets:

- `make init` – init + install hooks
- `make fmt` – format
- `make validate` – terraform validate
- `make lint` – tflint + checks
- `make test` – Terratest
- `make docs` – regenerate docs

---

### Notes

- This variant intentionally omits Litestream & backup automation.
- For production-grade backups, consider exporting SQLite periodically or enabling a replication strategy in a fork.
- If you need private-only services, set `allow_unauthenticated = false` and handle IAM bindings externally.
