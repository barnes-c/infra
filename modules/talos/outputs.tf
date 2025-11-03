output "talosconfig" {
  value     = data.talos_machine_configuration.controlplane
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.barnes-lab.kubeconfig_raw
  sensitive = true
}
