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
