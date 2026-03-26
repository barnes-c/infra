# infra

Talos Linux cluster on Raspberry Pi hardware, provisioned with OpenTofu.

## Hardware

| Node | Board | Role | IP | Storage |
|------|-------|------|----|---------|
| rp5b-cp-01 | RPi 5B 16GB | Control plane | `192.168.1.10` | SD card (OS) + 2× 2TB SATA SSD via Radxa Penta HAT |
| cm5-wk-01 | RPi CM5 8GB | Worker | `192.168.1.11` | eMMC (OS) + 256GB NVMe |
| cm5-wk-02 | RPi CM5 8GB | Worker | `192.168.1.12` | eMMC (OS) + 256GB NVMe |

## Step 1 — Build images

```sh
make all
```

This uploads schematics to [factory.talos.dev](https://factory.talos.dev) and downloads the
`metal-arm64.raw.xz` images into `images/`.

## Step 2 — Flash nodes

### RPi5B (SD card)

```sh
xz -d images/talos-rpi5b.raw.xz
diskutil list
diskutil unmountDisk /dev/diskX
sudo dd if=images/talos-rpi5b.raw of=/dev/rdiskX bs=4M 
diskutil eject /dev/diskX
```

Insert the SD card into the RPi5B and power on. The two SSDs on the Penta SATA HAT
appear as `/dev/sda` and `/dev/sdb` after boot.

### CM5 on NanoCluster (eMMC via rpiboot)

1. Hold the **BOOT** button on the NanoCluster adapter board.
2. Connect USB-C from the adapter to your host machine.
3. Run `sudo rpiboot` — the eMMC appears as a USB mass storage device.
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
tofu output -raw kubeconfig > ~/.kube/config
tofu output -raw talosconfig > ~/.talos/config
```
