locals {
  control_plane_ips = [for node in local.control_planes : node.ip]
  control_planes = {
    for k, v in var.nodes : k => v if v.role == "controlplane"
  }
  workers = {
    for k, v in var.nodes : k => v if v.role == "worker"
  }

  common_patch = {
    machine = {
      time = {
        servers = ["time.cloudflare.com", "ntp.ubuntu.com"]
      }
      kubelet = {
        extraArgs = {
          rotate-server-certificates = "true"
        }
      }
      features = {
        rbac                 = true
        stableHostname       = true
        apidCheckExtKeyUsage = true
        diskQuotaSupport     = true
        kubePrism = {
          enabled = true
          port    = 7445
        }
        hostDNS = {
          enabled              = true
          resolveMemberNames   = true
          forwardKubeDNSToHost = false
        }
      }
    }
  }
}

resource "talos_machine_secrets" "cluster" {}

data "talos_client_configuration" "cluster" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.cluster.client_configuration
  endpoints            = local.control_plane_ips
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.cluster.machine_secrets

  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${var.cluster_vip}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.cluster.machine_secrets

  talos_version      = var.talos_version
  kubernetes_version = var.kubernetes_version
}

resource "talos_machine_configuration_apply" "controlplane" {
  for_each = local.control_planes

  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = each.value.ip
  endpoint                    = each.value.ip
  apply_mode                  = "auto"

  config_patches = [
    yamlencode(local.common_patch),
    yamlencode({
      machine = {
        network = { hostname = each.key }
        install = {
          disk  = each.value.install_disk
          image = startswith(each.key, "rp5b-") ? var.talos_image_rp5b : var.talos_image_cm5
        }
        disks = each.value.storage_disks != null ? [
          for idx, disk in each.value.storage_disks : {
            device     = disk
            partitions = [{ mountpoint = "/var/mnt/storage${idx}" }]
          }
        ] : []
      }
      cluster = {
        allowSchedulingOnControlPlanes = true
        etcd = {
          advertisedSubnets = ["192.168.0.0/16"]
        }
        network = { cni = { name = "none" } }
        proxy   = { disabled = true }
      }
    }),
  ]

  on_destroy = {
    reboot = true
    reset  = true
  }
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = local.workers

  client_configuration        = talos_machine_secrets.cluster.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value.ip
  endpoint                    = each.value.ip
  apply_mode                  = "auto"

  config_patches = [
    yamlencode(local.common_patch),
    yamlencode({
      machine = {
        network = { hostname = each.key }
        install = {
          disk  = each.value.install_disk
          image = startswith(each.key, "rp5b-") ? var.talos_image_rp5b : var.talos_image_cm5
        }
        disks = each.value.storage_disks != null ? [
          for idx, disk in each.value.storage_disks : {
            device     = disk
            partitions = [{ mountpoint = "/var/mnt/storage${idx}" }]
          }
        ] : []
      }
      cluster = {
        network = { cni = { name = "none" } }
        proxy   = { disabled = true }
      }
    }),
  ]

  on_destroy = {
    reboot = true
    reset  = true
  }
}

resource "talos_machine_bootstrap" "cluster" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = local.control_plane_ips[0]
  endpoint             = local.control_plane_ips[0]

  depends_on = [talos_machine_configuration_apply.controlplane]
}

resource "talos_cluster_kubeconfig" "cluster" {
  client_configuration = talos_machine_secrets.cluster.client_configuration
  node                 = local.control_plane_ips[0]
  endpoint             = local.control_plane_ips[0]

  depends_on = [talos_machine_bootstrap.cluster]
}
