terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
  }
  required_version = ">= 1.14.4"
}
