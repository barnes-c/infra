locals {
  controlplane_ips = sort(keys(var.talos_node_data.controlplanes))
  bootstrap_node   = local.controlplane_ips[0]
}

resource "talos_cluster_kubeconfig" "barnes-lab" {
  depends_on                   = [talos_machine_bootstrap.node]
  client_configuration         = talos_machine_secrets.node.client_configuration
  node                         = local.bootstrap_node
  endpoint                     = local.bootstrap_node
  certificate_renewal_duration = "720h"
}
