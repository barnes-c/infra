provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "admin@barnes-lab"
}

provider "helm" {
  kubernetes = {
    config_path    = pathexpand("~/.kube/config")
    config_context = "admin@barnes-lab"
  }
}
