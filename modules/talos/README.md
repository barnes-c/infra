# Talos Module

This module provisions a [Talos Linux](https://www.talos.dev/) Kubernetes cluster on bare metal nodes (Raspberry Pi 4/5).

## What is Talos?

Talos is a modern, minimal, and secure Linux distribution designed specifically for running Kubernetes. Key features:

- **Immutable**: No shell, no SSH - managed entirely via API
- **Minimal**: Only includes what's needed for Kubernetes
- **Secure**: Reduced attack surface, automatic updates
- **API-driven**: All configuration via `talosctl` or Terraform

This brings the huge benefit that you don't have to manage the OS and only your K8s cluster.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/) >= 1.14.4
- [talosctl](https://www.talos.dev/v1.12/introduction/getting-started/#talosctl) CLI installed
- Raspberry Pi 4/5
- SD card for initial boot
- (Optional) SSD/NVMe for installation target

## Setup Guide

### 1. Download the Talos Image

Download the appropriate image for your hardware from the [Talos Image Factory](https://factory.talos.dev/):

```bash
# For Raspberry Pi with default extensions
curl -LO "https://factory.talos.dev/image/f78ef13e134c31401a21387bd8eb9019ce91d28da9fbf7ec0f0ac2572f2fb644/v1.12.2/metal-arm64.raw.xz"
```

### 2. Flash the SD Card

```bash
# Find your SD card device
diskutil list

# Unmount the SD card (replace disk4 with your actual disk)
diskutil unmountDisk /dev/disk4

# Flash the image (use rdisk for faster writes on macOS)
xzcat metal-arm64.raw.xz | sudo dd of=/dev/rdisk4 bs=4M status=progress

# Eject
diskutil eject /dev/disk4
```

### 3. Boot the Raspberry Pi

1. Insert the SD card into the Pi
2. Connect Ethernet cable
3. (Optional) Connect HDMI to see console output
4. Power on

The Pi will boot into **maintenance mode** and display its IP address on the console (or obtain one via DHCP).

### 4. Verify Connectivity

Wait ~60 seconds for boot, then verify the node is reachable:

```bash
# Check if the maintenance API responds
talosctl --nodes <NODE_IP> --endpoints <NODE_IP> version --insecure

# You should see both Client and Server versions
```

### 5. Configure and Apply with Terraform

Define your cluster in `main.tf`:

```hcl
module "talos" {
  source = "./modules/talos"

  cluster_vip = "192.168.1.177"

  nodes = {
    "cp-01" = {
      ip           = "192.168.1.177"
      role         = "controlplane"
      install_disk = "/dev/sda"  # Target disk for Talos installation
    }
  }
}
```

Apply the configuration:

```bash
terraform init
terraform apply
```

This will:

1. Generate cluster secrets
2. Apply machine configuration to each node
3. Bootstrap the cluster
4. Generate kubeconfig

### 6. Access the Cluster

```bash
# Save kubeconfig
terraform output -raw kubeconfig > ~/.kube/config

# Verify cluster access
kubectl get nodes

# Save talosconfig for talosctl commands
terraform output -raw talosconfig > ~/.talos/config
talosctl health
```

## Module Inputs

| Name                 | Description                         | Type          | Default            |
| -------------------- | ----------------------------------- | ------------- | ------------------ |
| `cluster_name`       | Name of the Talos cluster           | `string`      | `"barnes-lab"`     |
| `cluster_vip`        | Virtual IP for the cluster endpoint | `string`      | required           |
| `talos_version`      | Talos version                       | `string`      | `"v1.12.2"`        |
| `kubernetes_version` | Kubernetes version                  | `string`      | `"1.35.0"`         |
| `talos_image`        | Talos factory installer image       | `string`      | (see variables.tf) |
| `nodes`              | Map of node configurations          | `map(object)` | required           |

### Node Configuration

Each node in the `nodes` map requires:

| Field          | Description                                 |
| -------------- | ------------------------------------------- |
| `ip`           | Node IP address                             |
| `role`         | `"controlplane"` or `"worker"`              |
| `install_disk` | Disk to install Talos to (e.g., `/dev/sda`) |
| `extra_disks`  | Optional list of additional disks to mount  |

## Module Outputs

| Name          | Description                            |
| ------------- | -------------------------------------- |
| `talosconfig` | Talos client configuration (sensitive) |
| `kubeconfig`  | Kubernetes kubeconfig (sensitive)      |

## References

- [Talos Documentation](https://www.talos.dev/v1.12/)
- [Talos Image Factory](https://factory.talos.dev/)
- [Terraform Provider](https://registry.terraform.io/providers/siderolabs/talos/latest/docs)
- [talosctl Reference](https://www.talos.dev/v1.12/reference/cli/)
