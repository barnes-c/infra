variable "apple_domain_verification_code" {
  description = "Apple domain verification code"
  type        = string
  sensitive   = true
}

variable "cloudflare_zones" {
  type        = map(string)
  description = "Map of logical zone names to DNS zone names"
  default = {
    biz = "barnes.biz"
    # cloud = "barnes.cloud"
    # yana  = "holoborodko.xyz"
  }
}
