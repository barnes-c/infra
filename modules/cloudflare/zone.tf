data "cloudflare_zones" "zones" {
  for_each = var.cloudflare_zones
  name     = each.value
}
