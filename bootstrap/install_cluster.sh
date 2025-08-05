#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi


REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

### CONFIG SECTION ###
INSTALL_K3S="${INSTALL_K3S:-true}"
K3S_VERSION="v1.33.3+k3s1"
KUBECONFIG="/etc/rancher/k3s/k3s.yaml"
LONGHORN_SC_NAME="longhorn"

### 1. Install helm and repos ###
if ! command -v helm >/dev/null; then
    echo "Installing Helm..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

### 2. Add/update Helm repos ###
echo "Configuring Helm repositories..."
helm repo add cilium https://helm.cilium.io || true
helm repo add argo https://argoproj.github.io/argo-helm || true
helm repo update
echo "Updating Helm dependencies..."
helm dependency update "${REPO_ROOT}/bootstrap/cilium"
helm dependency update "${REPO_ROOT}/bootstrap/argocd"

### 3. Use DNS.sb for privacy ###
echo "Writing custom resolv.conf for CoreDNS..."
cat <<EOF > /etc/k3s-resolv.conf
nameserver 185.222.222.222
nameserver 45.11.45.11
nameserver 2a09::      # Swisscows IPv6
nameserver 2a11::      # Alternate IPv6
EOF

### 4. Install k3s ###
if [ "$INSTALL_K3S" = "true" ]; then
    echo "Installing k3s..."

    K3S_IP=$(hostname -I | awk '{print $1}')

    curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" \
        INSTALL_K3S_EXEC=" \
            server \
            --node-ip=$K3S_IP \
            --advertise-address=$K3S_IP \
            --disable traefik \
            --disable servicelb \
            --disable-network-policy \
            --flannel-backend=none \
            --secrets-encryption" \
        sh -

    echo "Waiting for Kubernetes API..."
    until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
fi

export KUBECONFIG=$KUBECONFIG

### 5. Install Cilium ###
echo "Installing Cilium..."
helm upgrade --install cilium "${REPO_ROOT}/bootstrap/cilium" \
    --namespace kube-system \
    --create-namespace \
    -f "${REPO_ROOT}/bootstrap/cilium/values.yaml"

### 6. Install raw ArgoCD ###
echo "Installing ArgoCD..."
helm upgrade --install argocd "${REPO_ROOT}/bootstrap/argocd" \
    --namespace argocd \
    --create-namespace \
    -f ./bootstrap/argocd/values.yaml

kubectl rollout status -n argocd deployment/argocd-server --timeout=180s

### 7. Apply AppProjects before Applications ###
echo "Applying ArgoCD projects..."
kubectl apply -f "${REPO_ROOT}/argocd/core/projects/core-project.yaml"
kubectl apply -f "${REPO_ROOT}/argocd/core/projects/default-project.yaml"

### 8. Apply core-root (starts ArgoCD self-management) ###
echo "Bootstrapping ArgoCD GitOps apps..."
kubectl apply -f "${REPO_ROOT}/argocd/core/core-root.yaml"

echo "Bootstrap complete. ArgoCD is now managing the cluster."
