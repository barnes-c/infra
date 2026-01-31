variable "argocd_apps_path" {
  description = "Path within the repo containing Application manifests"
  type        = string
  default     = "apps"
}

variable "argocd_apps_repo" {
  description = "Git repository URL containing ArgoCD Application manifests"
  type        = string
  default     = "https://github.com/barnes-c/gitops-repo"
}

variable "argocd_apps_repo_revision" {
  description = "Git revision (branch, tag, commit) to track"
  type        = string
  default     = "HEAD"
}

variable "argocd_enabled" {
  description = "Enable ArgoCD bootstrap"
  type        = bool
  default     = true
}

variable "argocd_values" {
  description = "Additional Helm values for ArgoCD (merged with defaults)"
  type        = any
  default     = {}
}

variable "cilium_enabled" {
  description = "Enable Cilium CNI bootstrap"
  type        = bool
  default     = true
}

variable "cilium_values" {
  description = "Additional Helm values for Cilium (merged with defaults)"
  type        = any
  default     = {}
}
