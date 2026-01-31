module "talos" {
  source = "./modules/talos"

  cluster_vip = "192.168.1.177"

  nodes = {
    "rp-cp-01" = {
      ip           = "192.168.1.177"
      role         = "controlplane"
      install_disk = "/dev/sda"
    }
  }
}


