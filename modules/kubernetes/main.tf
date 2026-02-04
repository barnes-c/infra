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
  version          = "1.19.0"
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
  version          = "9.4.0"
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

resource "kubernetes_manifest" "argocd_apps_root" {
  count = var.argocd_enabled && var.argocd_apps_repo != "" ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "apps-root"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.argocd_apps_repo
        targetRevision = var.argocd_apps_repo_revision
        path           = var.argocd_apps_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        retry = {
          limit = 5
          backoff = {
            duration    = "5s"
            factor      = 2
            maxDuration = "3m"
          }
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
