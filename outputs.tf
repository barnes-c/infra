output "talosconfig" {
  description = "Talos configuration"
  value       = module.talos.talosconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes configuration"
  value       = module.talos.kubeconfig
  sensitive   = true
}
