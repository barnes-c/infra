# infra

Talos Linux cluster on Raspberry Pi hardware, provisioned with OpenTofu.

## Hardware

| Node | Board | Role | IP | Storage |
|------|-------|------|----|---------|
| — | — | VIP (cluster API) | `192.168.1.10` | — |
| rp5b-cp-01 | [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/) 16GB | Control plane | `192.168.1.11` | SD card + 2× 2TB SATA SSD via Radxa Penta HAT |
| rpi4b-wk-01 | [Raspberry Pi 4B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) 8GB | Worker | `192.168.1.12` | SD card + 500GB USB SSD |
| cm5-wk-01 | [Raspberry Pi CM5](https://www.raspberrypi.com/products/compute-module-5/) 8GB | Worker | `192.168.1.13` | 256GB NVMe |
| cm5-wk-02 | [Raspberry Pi CM5](https://www.raspberrypi.com/products/compute-module-5/) 8GB | Worker | `192.168.1.14` | 256GB NVMe |

## Step 1 — Build images

```sh
make all
```

This uploads schematics to [factory.talos.dev](https://factory.talos.dev) and downloads the
`metal-arm64.raw.xz` images into `images/`.

## Step 2 — Flash nodes

### RPi5B and RPi4B via SD card

```sh
xz -d images/talos-<rpi5b|rpi4b>.raw.xz
diskutil list
diskutil unmountDisk /dev/diskX
sudo dd if=images/talos-<rpi5b|rpi4b>.raw of=/dev/rdiskX bs=4M 
diskutil eject /dev/diskX
```

Insert the SD card into the device and power on.

### CM5 on NanoCluster (eMMC via rpiboot)

1. Hold the **BOOT** button on the NanoCluster adapter board.
2. Connect USB-C from the adapter to your host machine.
3. Run `sudo rpiboot`. The eMMC appears as a USB mass storage device.
4. Flash:

   ```sh
   xz -d images/talos-cm5.raw.xz
   diskutil list
   diskutil unmountDisk /dev/diskX
   sudo dd if=images/talos-cm5.raw of=/dev/rdiskX bs=4M
   diskutil eject /dev/diskX
   ```

## Step 3 — Provision the cluster

```sh
cd talos/
tofu init
tofu apply
tofu output -raw kubeconfig > $HOME/.kube/config
tofu output -raw talosconfig > $HOME/.talos/config
```

## Step 4 — Approve kubelet CSRs

Kubelet server certificate rotation is enabled. Kubernetes does not auto-approve kubelet
serving CSRs, so they must be approved manually after bootstrap:

```sh
kubectl get csr
kubectl certificate approve <csr-name>
```

This is required for `kubectl exec`, `kubectl logs`, and `kubectl port-forward` to work.
CSRs will need re-approving when they rotate (~1 year). TODO:
[kubelet-csr-approver](https://github.com/postfinance/kubelet-csr-approver) in ArgoCD
