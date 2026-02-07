# Kubernetes Module

Bootstrap module for Kubernetes infrastructure on a Talos Linux cluster.

This repository bootstraps the core infrastructure. Everything else is deployed later from a separate ArgoCD repository:

- **Terraform**  installs Cilium and ArgoCD during initial bootstrap
- **ArgoCD** manages all components after bootstrap, including itself
- `lifecycle { ignore_changes = all }` prevents Terraform from reverting ArgoCD changes

## Prerequisites

- Talos cluster with CNI disabled (`cluster.network.cni.name: none`)
- Talos cluster with kube-proxy disabled (`cluster.proxy.disabled: true`)
- Valid kubeconfig from the talos module
- Separate GitOps repo for ArgoCD Applications

## Usage

```hcl
module "kubernetes" {
  source = "./modules/kubernetes"

  kubeconfig = module.talos.kubeconfig
}
```

## Inputs

|Name|Description|Type|Default|
|---|---|---|---|
|`kubeconfig`|Kubeconfig from Talos module|`string`|required|
|`cilium_enabled`|Enable Cilium bootstrap|`bool`|`true`|
|`cilium_version`|Cilium chart version (initial)|`string`|`"1.18.6"`|
|`cilium_values`|Additional Cilium Helm values|`any`|`{}`|
|`argocd_enabled`|Enable ArgoCD bootstrap|`bool`|`true`|
|`argocd_version`|ArgoCD chart version (initial)|`string`|`"9.3.7"`|
|`argocd_values`|Additional ArgoCD Helm values|`any`|`{}`|
|`argocd_namespace`|ArgoCD namespace|`string`|`"argocd"`|

## Outputs

|Name|Description|
|---|---|
|`cilium_status`|Cilium deployment status|
|`argocd_status`|ArgoCD deployment status|
|`argocd_initial_admin_secret`|Secret name for ArgoCD admin password|

## Accessing ArgoCD

```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Post-Bootstrap Steps

1. Create a GitOps repo with ArgoCD Applications for:
   - Cilium (manages upgrades)
   - Longhorn (storage)
   - ArgoCD (self-managed)
   - Your applications

2. Add the repo to ArgoCD and deploy the root Application

3. Verify `terraform plan` shows no changes (ignore_changes working)
