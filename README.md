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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 4.52.1 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.45.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_record.frontend](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_record.pocketbase](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [google_cloud_run_domain_mapping.frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_domain_mapping.pocketbase](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping) | resource |
| [google_cloud_run_v2_service.frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service.pocketbase](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service_iam_member.frontend_invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_member) | resource |
| [google_cloud_run_v2_service_iam_member.pb_invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service_iam_member) | resource |
| [google_project_iam_member.pb_storage_admin_fuse](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.pb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_env"></a> [additional\_env](#input\_additional\_env) | Additional environment variables applied to PocketBase container | `map(string)` | `{}` | no |
| <a name="input_allow_unauthenticated"></a> [allow\_unauthenticated](#input\_allow\_unauthenticated) | Allow unauthenticated invocation of services (public access) | `bool` | `true` | no |
| <a name="input_app_subdomain"></a> [app\_subdomain](#input\_app\_subdomain) | Alias for frontend subdomain (if separate) used in DNS records | `string` | `"app"` | no |
| <a name="input_auth_subdomain"></a> [auth\_subdomain](#input\_auth\_subdomain) | Subdomain for PocketBase service (auth.example.com) | `string` | `"auth"` | no |
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | Base apex/root domain (example.com) for constructing service URLs | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare Zone ID for the base domain | `string` | `""` | no |
| <a name="input_cookie_domain"></a> [cookie\_domain](#input\_cookie\_domain) | Domain used for cross-service auth cookies (e.g. .example.com) | `string` | n/a | yes |
| <a name="input_enable_cloudflare_dns"></a> [enable\_cloudflare\_dns](#input\_enable\_cloudflare\_dns) | Whether to create Cloudflare DNS records for PocketBase and frontend | `bool` | `false` | no |
| <a name="input_enable_frontend_service"></a> [enable\_frontend\_service](#input\_enable\_frontend\_service) | Deploy frontend Cloud Run service when true and frontend\_image provided | `bool` | `false` | no |
| <a name="input_frontend_additional_env"></a> [frontend\_additional\_env](#input\_frontend\_additional\_env) | Additional env vars for frontend service | `map(string)` | `{}` | no |
| <a name="input_frontend_image"></a> [frontend\_image](#input\_frontend\_image) | Container image for Nginx SPA | `string` | `null` | no |
| <a name="input_frontend_subdomain"></a> [frontend\_subdomain](#input\_frontend\_subdomain) | Subdomain for frontend (app.example.com) | `string` | `"app"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Optional map of labels applied to supported resources | `map(string)` | `{}` | no |
| <a name="input_litestream_db_path"></a> [litestream\_db\_path](#input\_litestream\_db\_path) | Path to the PocketBase SQLite database file used by Litestream (inside container). | `string` | `"/pb/pb_data/data.db"` | no |
| <a name="input_litestream_replica_url"></a> [litestream\_replica\_url](#input\_litestream\_replica\_url) | Replica destination URL for Litestream (e.g. s3://bucket/path). Container must know how to auth. Null to disable injection. | `string` | `null` | no |
| <a name="input_litestream_restore"></a> [litestream\_restore](#input\_litestream\_restore) | Whether to run a Litestream restore on first start (container entrypoint must implement logic). | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix used for naming resources (e.g. myapp-dev) | `string` | n/a | yes |
| <a name="input_pocketbase_image"></a> [pocketbase\_image](#input\_pocketbase\_image) | Container image reference for PocketBase (supports Litestream if baked-in) | `string` | n/a | yes |
| <a name="input_pocketbase_min_instances"></a> [pocketbase\_min\_instances](#input\_pocketbase\_min\_instances) | Minimum Cloud Run instances for PocketBase (keep warm) | `number` | `0` | no |
| <a name="input_pocketbase_resources"></a> [pocketbase\_resources](#input\_pocketbase\_resources) | Resource settings for the PocketBase Cloud Run container (cpu as number, memory as string like 512Mi / 1Gi) | <pre>object({<br/>    cpu    = number<br/>    memory = string<br/>  })</pre> | <pre>{<br/>  "cpu": 1,<br/>  "memory": "512Mi"<br/>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where resources will be deployed | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Primary region for Cloud Run services and buckets | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_domain"></a> [auth\_domain](#output\_auth\_domain) | Auth (PocketBase) domain constructed from subdomain + base domain |
| <a name="output_cloudflare_frontend_record"></a> [cloudflare\_frontend\_record](#output\_cloudflare\_frontend\_record) | Cloudflare record (subdomain) created for Frontend (if enabled). |
| <a name="output_cloudflare_pocketbase_record"></a> [cloudflare\_pocketbase\_record](#output\_cloudflare\_pocketbase\_record) | Cloudflare record (subdomain) created for PocketBase (if enabled). |
| <a name="output_cookie_domain"></a> [cookie\_domain](#output\_cookie\_domain) | Cookie domain shared across services |
| <a name="output_frontend_custom_domain"></a> [frontend\_custom\_domain](#output\_frontend\_custom\_domain) | Custom domain mapped to the Frontend service (if enabled). |
| <a name="output_frontend_url"></a> [frontend\_url](#output\_frontend\_url) | Frontend service URL (null if disabled) |
| <a name="output_litestream_db_path"></a> [litestream\_db\_path](#output\_litestream\_db\_path) | Path to the SQLite DB used by Litestream |
| <a name="output_litestream_replica_url"></a> [litestream\_replica\_url](#output\_litestream\_replica\_url) | Litestream replica URL injected (null if disabled) |
| <a name="output_pocketbase_custom_domain"></a> [pocketbase\_custom\_domain](#output\_pocketbase\_custom\_domain) | Custom domain mapped to the PocketBase service (if enabled). |
| <a name="output_pocketbase_service_account"></a> [pocketbase\_service\_account](#output\_pocketbase\_service\_account) | Service account email used by PocketBase |
| <a name="output_pocketbase_url"></a> [pocketbase\_url](#output\_pocketbase\_url) | Deployed PocketBase service base URL |
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
