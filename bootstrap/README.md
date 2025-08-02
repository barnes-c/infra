# bootstrap
In this directory are critical systems that need to be running before anything else is deployed.

Priority:
1. Cilium
2. ArgoCD

After these systems have been deployed ArgoCD can manage itself and deploy other apps.

Only run the script once. It installs k3s and then cilium. After that argocd takes over deploying the rest

run script as root!!!
##

add advertising ip for k3s
add tsln for k3s