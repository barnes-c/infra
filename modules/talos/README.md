# Talos

[Talos Linux](https://www.talos.dev/) is a secure, immutable, and minimal operating system purpose-built for running Kubernetes.
It eliminates configuration drift by enforcing an Infrastructure-as-Code (IaC) model for system management.

Because of its API-driven architecture, Talos integrates seamlessly with IaC tools such as [OpenTofu](https://opentofu.org/),
enabling fully automated provisioning and lifecycle management of clusters.

In this module, the Kubernetes cluster `barnes-lab` is initialized,
and additional nodes are joined to it using declarative configuration.
