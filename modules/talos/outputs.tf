output "talosconfig" {
  description = "Talos configuration"
  value       = data.talos_client_configuration.cluster.talos_config
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes configuration"
  value       = talos_cluster_kubeconfig.cluster.kubeconfig_raw
  sensitive   = true
}
