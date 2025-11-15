output "talos_config" {
  value     = module.talos.talosconfig
  sensitive = true
}

output "talos_kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}

output "talos_machine_secrets_yaml" {
  value     = module.talos.machine_secrets_yaml
  sensitive = true
}

output "talos_controlplane_machine_config" {
  value     = module.talos.controlplane_machine_config
  sensitive = true
}
