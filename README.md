# Infra

This repository holds the Infrastructure-as-Code (IaC) definitions for my Cloudflare resources and a [Kubernetes](https://kubernetes.io/) cluster running on [TalOS](https://www.talos.dev/).

## Modules

| Module | Description |
| ------ | ----------- |
| [talos](modules/talos/README.md) | Provisions a Talos Linux Kubernetes cluster on Raspberry Pi |
| [kubernetes](modules/kubernetes/README.md) | Deploys core Kubernetes resources and applications |
| [cloudflare](modules/cloudflare/README.md) | Manages Cloudflare DNS zones and records |

## License

- This repository is licensed under the [Apache License, Version 2.0](https://github.com/barnes-c/cluster/blob/master/LICENSE).
