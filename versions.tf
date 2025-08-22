// Terraform and provider version constraints
// Define required versions for Terraform and providers

terraform {
  required_version = ">= 1.8.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.49.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}
