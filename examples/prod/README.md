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

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->