variable "talos_name" {
  description = "Talos cluster name"
  type        = string
  default     = "barnes-lab-1"
}

variable "talos_endpoint" {
  description = "Talos cluster endpoint"
  type        = string
}

variable "talos_node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
  default = {
    controlplanes = {
      "192.168.178.20" = {
        install_disk = "/dev/sda"
      }
    }
    workers = {}
  }
}
