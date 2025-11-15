# module "cloudflare" {
#   source = "./modules/cloudflare"

#   apple_domain_verification_code = var.apple_domain_verification_code
#   cloudflare_api_token           = var.cloudflare_api_token
# }

module "kubernetes" {
  source = "./modules/kubernetes"
}


