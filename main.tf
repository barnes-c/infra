# module "cloudflare" {
#   source = "./modules/cloudflare"

#   apple_domain_verification_code = var.apple_domain_verification_code
#   cloudflare_api_token           = var.cloudflare_api_token
# }

module "talos" {
  source = "./modules/talos"

  talos_endpoint  = var.talos_endpoint
  talos_name      = var.talos_name
  talos_node_data = var.talos_node_data
}
