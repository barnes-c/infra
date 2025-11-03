resource "talos_cluster_kubeconfig" "barnes-lab" {
  depends_on           = [talos_machine_bootstrap.node]
  client_configuration = talos_machine_secrets.node.client_configuration
  node                 = [for k, v in var.talos_node_data.controlplanes : k][0]
}
