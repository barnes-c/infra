resource "cloudflare_dns_record" "root_web_a" {
  for_each = data.cloudflare_zones.zones

  zone_id = each.value.result[0].id
  name    = each.value.name
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "wildcard_web_a" {
  for_each = data.cloudflare_zones.zones

  zone_id = each.value.result[0].id
  name    = "*"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "root_web_aaaa" {
  for_each = data.cloudflare_zones.zones

  zone_id = each.value.result[0].id
  name    = each.value.name
  type    = "AAAA"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "wildcard_web_aaaa" {
  for_each = data.cloudflare_zones.zones

  zone_id = each.value.result[0].id
  name    = "*"
  type    = "AAAA"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "verify_apple_txt" {
  zone_id = data.cloudflare_zones.zones["biz"].result[0].id
  name    = data.cloudflare_zones.zones["biz"].name
  type    = "TXT"
  ttl     = 60
  content = "apple-domain=${var.apple_domain_verification_code}"
}

resource "cloudflare_dns_record" "dkim_icloud_cname" {
  zone_id = data.cloudflare_zones.zones["biz"].result[0].id
  name    = "sig1._domainkey.${data.cloudflare_zones.zones["biz"].name}"
  type    = "CNAME"
  ttl     = 1
  content = "sig1.dkim.${data.cloudflare_zones.zones["biz"].name}.at.icloudmailadmin.com"
  proxied = true
}

resource "cloudflare_dns_record" "mail_spf_txt" {
  zone_id = data.cloudflare_zones.zones["biz"].result[0].id
  name    = data.cloudflare_zones.zones["biz"].name
  type    = "TXT"
  ttl     = 60
  content = "v=spf1 include:icloud.com ~all"
}

resource "cloudflare_dns_record" "mail_mx_10" {
  zone_id  = data.cloudflare_zones.zones["biz"].result[0].id
  name     = data.cloudflare_zones.zones["biz"].name
  type     = "MX"
  ttl      = 60
  content  = "mx01.mail.icloud.com"
  priority = 10
}

resource "cloudflare_dns_record" "mail_mx_20" {
  zone_id  = data.cloudflare_zones.zones["biz"].result[0].id
  name     = data.cloudflare_zones.zones["biz"].name
  type     = "MX"
  ttl      = 60
  content  = "mx02.mail.icloud.com"
  priority = 20
}
