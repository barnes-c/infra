provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "helm" {
  kubernetes = {
    host                   = yamldecode(module.talos.kubeconfig).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(module.talos.kubeconfig).clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(yamldecode(module.talos.kubeconfig).users[0].user.client-certificate-data)
    client_key             = base64decode(yamldecode(module.talos.kubeconfig).users[0].user.client-key-data)
  }
}

provider "kubernetes" {
  host                   = yamldecode(module.talos.kubeconfig).clusters[0].cluster.server
  cluster_ca_certificate = base64decode(yamldecode(module.talos.kubeconfig).clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(module.talos.kubeconfig).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(module.talos.kubeconfig).users[0].user.client-key-data)
}

provider "talos" {}
