// Local values centralizing naming & domains
locals {
  pb_base_name = "${var.name_prefix}-pb"
  fe_base_name = "${var.name_prefix}-web"

  auth_domain     = "${var.auth_subdomain}.${var.base_domain}"
  frontend_domain = "${var.frontend_subdomain}.${var.base_domain}"

  resource_prefix = var.name_prefix
}
