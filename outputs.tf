output "argocd_initial_admin_secret" {
  description = "ArgoCD initial admin secret"
  value       = module.kubernetes.argocd_initial_admin_secret
  sensitive   = true
}

output "argocd_status" {
  description = "ArgoCD deployment status"
  value       = module.kubernetes.argocd_status
}

output "cilium_status" {
  description = "Cilium deployment status"
  value       = module.kubernetes.cilium_status
}

output "kubeconfig" {
  description = "Kubernetes configuration"
  value       = module.talos.kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talos configuration"
  value       = module.talos.talosconfig
  sensitive   = true
}
