variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "barnes-lab"
}

variable "cluster_vip" {
  description = "Virtual IP for the cluster endpoint"
  type        = string
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.12.2"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.35.0"
}

variable "talos_image" {
  description = "Default Raspberry Pi Talos image to use"
  type        = string
  default     = "factory.talos.dev/installer/f78ef13e134c31401a21387bd8eb9019ce91d28da9fbf7ec0f0ac2572f2fb644:v1.12.2"
}

variable "nodes" {
  description = "Map of node configurations"
  type = map(object({
    ip           = string
    role         = string # "controlplane" or "worker"
    install_disk = string
    extra_disks  = optional(list(string), [])
  }))
}
