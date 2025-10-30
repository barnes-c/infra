data "cloudflare_zones" "selected" {
  name = var.cloudflare_dns_zone_name
}
