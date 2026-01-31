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

variable "argocd_version" {
  description = "ArgoCD Helm chart version for initial bootstrap"
  type        = string
  default     = "9.3.7"
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

variable "cilium_version" {
  description = "Cilium Helm chart version for initial bootstrap"
  type        = string
  default     = "1.18.6"
}

variable "kubeconfig" {
  description = "Kubeconfig content from the Talos module"
  type        = string
  sensitive   = true
}
