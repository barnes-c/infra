output "argocd_initial_admin_secret" {
  description = "Name of the Kubernetes secret containing ArgoCD initial admin password"
  value       = var.argocd_enabled ? "argocd-initial-admin-secret" : null
}

output "argocd_status" {
  description = "ArgoCD deployment status"
  value = var.argocd_enabled ? {
    name      = helm_release.argocd[0].name
    namespace = helm_release.argocd[0].namespace
    version   = helm_release.argocd[0].version
    status    = helm_release.argocd[0].status
  } : null
}

output "cilium_status" {
  description = "Cilium deployment status"
  value = var.cilium_enabled ? {
    name      = helm_release.cilium[0].name
    namespace = helm_release.cilium[0].namespace
    version   = helm_release.cilium[0].version
    status    = helm_release.cilium[0].status
  } : null
}
