variable "apple_domain_verification_code" {
  description = "Apple domain verification code for barnes.biz"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}

variable "cloudflare_dns_zone_name" {
  description = "Cloudflare zone name"
  type        = string
  default     = "barnes.biz"
}

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
      "10.5.0.2" = {
        install_disk = "/dev/sda"
      }
    }
    workers = {}
  }
}
