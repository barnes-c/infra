# Cluster

A personal k3s cluster running on a NanoCluster with Raspberry CM5 and LonganPi LPi3H nodes. This cluster deploys its services using GitOps via ArgoCD

---

## Table of Contents

- [Hardware](#hardware)
  - [Cluster Board: Sipeed NanoCluster](#cluster-board-sipeed-nanocluster)
  - [Cluster Compute Modules](#cluster-compute-modules)
  - [Cluster Storage](#cluster-storage)
  - [Power Management](#power-management)
  - [Cost](#cost)
- [Cluster Setup](#cluster-setup)
  - [Networking: Cilium](#networking-cilium)
  - [Storage: Longhorn](#storage-longhorn)
  - [TLS & Certificates: cert-manager](#tls--certificates-cert-manager)
  - [GitOps: ArgoCD](#gitops-argocd)
- [Applications Deployed via ArgoCD](#applications-deployed-via-argocd)
- [License](#license)

---

## Hardware
### Cluster Board: Sipeed NanoCluster

The cluster is built on the [Sipeed NanoCluster](https://classic.sipeed.com/nanocluster). ![Sipeed NanoCluster](https://github.com/barnes-c/cluster/blob/master/docs/images/NanoCluster.png)

### Cluster Compute Modules
In my set up the cluster board is up to use two Raspberry [CM5s](https://www.raspberrypi.com/products/compute-module-5/?variant=cm5-104032) and one [CM4](https://www.raspberrypi.com/products/compute-module-4/?variant=raspberry-pi-cm4001000), also one [Longan Pi 3H](https://wiki.sipeed.com/hardware/en/longan/h618/lpi3h/1_intro.html). This brings the cluster to a total of 16 cores and 22GB RAM

![CM5](https://github.com/barnes-c/cluster/blob/master/docs/images/CM5.webp)

![Longan Pi 3H](https://github.com/barnes-c/cluster/blob/master/docs/images/LM3H.jpg)

### Cluster Storage
Each CM has a [Transcend M.2 NVMe SSD](https://www.conrad.de/de/p/transcend-mts400s-256-gb-interne-m-2-pcie-nvme-ssd-2242-pcie-nvme-3-0-x4-retail-ts256gmte400s-2796245.html?utm_source=google&utm_medium=organic&utm_campaign=shopping) attached over a SoM. So four NVMe's totalling to 768GB of storage

![Transcend M.2 NVMe SSD](https://github.com/barnes-c/cluster/blob/master/docs/images/NVME.webp)


### Power Management
The cluster is powered with PoE. The PoE module for the Sipeed NanoCluster is capped at 60W. The current installed hardware draws:
- 2x CM5: 7.5W
- 1x CM4: 6W
- 1x LM3H: 4W
- 3x NVMe: 3W

Totallying a max of 34 Watts so there is room for more CMs

### Cost
The cluster cost me in total 539$
* NanoCluster: 1x 135$
* CM5 2x 92$
* CM4: 1x 50$
* LM3H: 1x 35$
* NVMe: 3x 45$

---

## Cluster Setup


## Applications Deployed via ArgoCD

All applications are defined in the Git repository and deployed via ArgoCD using Helm charts or Kustomize.

### Core Infrastructure

- **Traefik** - Ingress controller for external HTTP/S traffic
- **cert-manager** - TLS certificate management
- **Longhorn** - Distributed block storage
- **Cilium** - CNI and network security

### Monitoring Stack

- **Prometheus** - Metrics collection and alerting
- **Grafana** - Metrics dashboard and visualization
- **Loki** - Log aggregation
- **Fluent Bit** - Log collection from nodes and containers

### Self-Hosted Applications

- **Immich** – Photo and video management
- **Min.io** – Object storage
- **WireGuard** – VPN access to the cluster

---

## Future work

Thing that need to be done are:
* Add fallback power when PoE (max 60W) is not enough
* Ansible playbook to deploy cluster + apps
* Ansible playbook to set up external Hashicorp Vault
* Deploy external Hashicorp Vault for secret management
* Set up provisioning for Grafana dashboards/alerts
* Set up PXE boot 
* Set longhorn as default storage class 
* Minecraft server

---

## License

- This repository is licensed under the [GNU AGPLv3](https://github.com/barnes-c/cluster/blob/master/LICENSE).

