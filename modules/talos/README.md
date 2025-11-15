<<<<<<< HEAD
# talos

## How to generate machine configurations

```bash
talosctl gen config \
    barnes-lab https://192.168.178.20:6443 \
    --config-patch @patches/disable-flannel.yaml \
    --config-patch @patches/disable-kube-proxy.yaml \
    -o ./config
```

## How to apply patches to talos nodes

### Control planes

```bash
talosctl apply-config \
  --nodes 192.168.178.20 \
  --file ./config/controlplane.yaml \
  --mode=auto
```

### Worker

```bash
talosctl apply-config \
  --nodes 192.168.178.XX \
  --file ./config/worker.yaml \
  --mode=auto
```

## How to upgrade talos nodes

```bash
talosctl upgrade \
  --nodes 192.168.178.20 \
  --image ghcr.io/siderolabs/installer:v1.11.5 \
  --preserve \
  --wait=true
```
=======
# Talos

[Talos Linux](https://www.talos.dev/) is a secure, immutable, and minimal operating system purpose-built for running Kubernetes.
It eliminates configuration drift by enforcing an Infrastructure-as-Code (IaC) model for system management.

Because of its API-driven architecture, Talos integrates seamlessly with IaC tools such as [OpenTofu](https://opentofu.org/),
enabling fully automated provisioning and lifecycle management of clusters.

In this module, the Kubernetes cluster `barnes-lab` is initialized,
and additional nodes are joined to it using declarative configuration.
>>>>>>> feat/add-talos-setup
