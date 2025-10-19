data "cloudflare_zones" "selected" {
  name = var.zone_name
}
