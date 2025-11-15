output "talosconfig" {
  value     = talos_cluster_kubeconfig.barnes-lab.kubeconfig_raw
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.barnes-lab.kubernetes_client_configuration
  sensitive = true
}

output "machine_secrets_yaml" {
  value     = talos_machine_secrets.node.machine_secrets
  sensitive = true
}

output "controlplane_machine_config" {
  value     = data.talos_machine_configuration.controlplane.machine_configuration
  sensitive = true
}
