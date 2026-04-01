variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "barnes-lab"
}

variable "cluster_vip" {
  description = "Virtual IP for the cluster API endpoint"
  type        = string
  default     = "192.168.1.10"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.35.0"
}

variable "nodes" {
  description = "Map of node configurations. Key is used as the hostname."
  type = map(object({
    ip           = string
    role         = string # "controlplane" or "worker"
    install_disk = string
    storage_disks = optional(list(object({
      device = string
      partitions = list(object({
        mountpoint = string
        size       = optional(string)
      }))
    })))
  }))
  default = {
    "rpi5b-cp-01" = {
      ip           = "192.168.1.11"
      role         = "controlplane"
      install_disk = "/dev/mmcblk0"
      storage_disks = [
        {
          device     = "/dev/sda"
          partitions = [{ mountpoint = "/var/lib/etcd", size = "20GiB" }]
        },
        {
          device     = "/dev/sdb"
          partitions = [{ mountpoint = "/var/mnt/storage1" }]
        },
      ]
    }
    "rpi4b-wk-01" = {
      ip           = "192.168.1.12"
      role         = "worker"
      install_disk = "/dev/mmcblk0"
      storage_disks = [
        {
          device     = "/dev/sda"
          partitions = [{ mountpoint = "/var/mnt/storage0" }]
        },
      ]
    }
    # "cm5-wk-01" = {
    #   ip            = "192.168.1.13"
    #   role          = "worker"
    #   install_disk  = "/dev/mmcblk0"
    #   storage_disks = ["/dev/nvme0n1"]
    # }
    # "cm5-wk-02" = {
    #   ip            = "192.168.1.14"
    #   role          = "worker"
    #   install_disk  = "/dev/mmcblk0"
    #   storage_disks = ["/dev/nvme0n1"]
    # }
  }
}

variable "talos_image_rpi4b" {
  description = "Talos factory installer image for Raspberry Pi 4B (schematic: rp4b)"
  type        = string
  default     = "factory.talos.dev/metal-installer/258bae9381b8132728d634f842c85f8c881717c57f95503b0c311602ee572d1d:v1.12.6" # Populated automatically by `make schematics`
}

variable "talos_image_cm5" {
  description = "Talos factory installer image for Raspberry Pi CM5 (schematic: cm5 on NanoCluster)"
  type        = string
  default     = "factory.talos.dev/metal-installer/313982b680c2507b839ad4cd287181a641ed9f9a9659294b744e840cb6576fe6:v1.12.6" # Populated automatically by `make schematics`
}

variable "talos_image_rpi5b" {
  description = "Talos factory installer image for Raspberry Pi 5B (schematic: rpi5b with Penta SATA HAT)"
  type        = string
  default     = "factory.talos.dev/metal-installer/313982b680c2507b839ad4cd287181a641ed9f9a9659294b744e840cb6576fe6:v1.12.6" # Populated automatically by `make schematics`
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.12.6"
}
