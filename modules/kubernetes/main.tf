locals {
  argocd_default_values = {
    server = {
      service = {
        type = "ClusterIP"
      }
    }
  }
  cilium_default_values = {
    securityContext = {
      capabilities = {
        ciliumAgent      = ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
        cleanCiliumState = ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
      }
    }

    cgroup = {
      autoMount = {
        enabled = false
      }
      hostRoot = "/sys/fs/cgroup"
    }

    ipam = {
      mode = "kubernetes"
    }

    kubeProxyReplacement = true
    k8sServiceHost       = "localhost"
    k8sServicePort       = 7445

    bpf = {
      hostLegacyRouting = true
    }

    gatewayAPI = {
      enabled = true
    }

    operator = {
      replicas = 1
    }
  }
}

resource "kubernetes_namespace_v1" "argocd" {
  count = var.argocd_enabled ? 1 : 0

  metadata {
    name = "argocd"
  }
}

resource "helm_release" "cilium" {
  count = var.cilium_enabled ? 1 : 0

  atomic = true

  name             = "cilium"
  namespace        = "kube-system"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  version          = var.cilium_version
  create_namespace = false

  wait          = true
  wait_for_jobs = true
  timeout       = 600

  values = [
    yamlencode(merge(local.cilium_default_values, var.cilium_values))
  ]

  lifecycle {
    ignore_changes = all
  }
}

resource "helm_release" "argocd" {
  count = var.argocd_enabled ? 1 : 0

  atomic = true

  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  create_namespace = false

  wait    = true
  timeout = 600

  values = [
    yamlencode(merge(local.argocd_default_values, var.argocd_values))
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd,
    helm_release.cilium
  ]

  lifecycle {
    ignore_changes = all
  }
}
