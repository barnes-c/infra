# Kubernetes

In this module Im installing the essential services and resources to my cluster, which was deployed with talos

Things Im deploying here:

- ArgoCD: This is being set up here. It is observing another Repo which has all the applications which it is deploying
- Cilium: This im deploying because I want to use Gateway API to manage the traffic of my cluster

talosctl -n 192.168.172.20 get machineconfig -o yaml > controlplane-recovered.yaml
