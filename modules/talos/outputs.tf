output "talosconfig" {
  value     = data.talos_client_configuration.node.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.barnes-lab.kubeconfig_raw
  sensitive = true
}
