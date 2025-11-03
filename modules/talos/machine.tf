resource "talos_machine_bootstrap" "node" {
  depends_on           = [talos_machine_configuration_apply.controlplane]
  client_configuration = talos_machine_secrets.node.client_configuration
  node                 = [for k, v in var.talos_node_data.controlplanes : k][0]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.node.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration

  for_each = var.talos_node_data.controlplanes
  node     = each.key

  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = coalesce(each.value.hostname, format("%s-cp-%s", var.talos_name, index(sort(keys(var.talos_node_data.controlplanes)), each.key)))
      install_disk = each.value.install_disk
    }),
    file("${path.module}/files/cp-scheduling.yaml"),
  ]
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.talos_name
  cluster_endpoint = var.talos_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.node.machine_secrets
}

resource "talos_machine_secrets" "node" {}
