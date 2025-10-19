resource "cloudflare_dns_record" "barnes_biz_root_ip4" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "barnes.biz"
  ttl     = 1
  type    = "A"
  comment = "DNS root A record created by Terraform"
  content = "149.172.144.12"
  proxied = true
}

resource "cloudflare_dns_record" "barnes_biz_wildcard_ip4" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "*"
  ttl     = 1
  type    = "A"
  comment = "DNS wildcard A record created by Terraform"
  content = "149.172.144.12"
  proxied = true
}

resource "cloudflare_dns_record" "barnes_biz_root_ip6" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "barnes.biz"
  ttl     = 1
  type    = "AAAA"
  comment = "DNS root AAAA record created by Terraform"
  content = "2a02:8071:3486:67a0:e65f:1ff:fea6:be19"
  proxied = true
}

resource "cloudflare_dns_record" "barnes_biz_wildcard_ip6" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "*"
  ttl     = 1
  type    = "AAAA"
  comment = "DNS wildcard AAAA record created by Terraform"
  content = "2a02:8071:3486:67a0:e65f:1ff:fea6:be19"
  proxied = true
}

resource "cloudflare_dns_record" "apple_domain_verification" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "barnes.biz"
  type    = "TXT"
  ttl     = 60
  content = var.apple_domain_verification_code
}

resource "cloudflare_dns_record" "icloud_dkim" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "sig1._domainkey.barnes.biz"
  type    = "CNAME"
  ttl     = 1
  content = "sig1.dkim.barnes.biz.at.icloudmailadmin.com"
  proxied = true
}

resource "cloudflare_dns_record" "icloud_spf" {
  zone_id = data.cloudflare_zones.selected.result[0].id
  name    = "barnes.biz"
  type    = "TXT"
  ttl     = 60
  content = "v=spf1 include:icloud.com ~all"
}

resource "cloudflare_dns_record" "mx01" {
  zone_id  = data.cloudflare_zones.selected.result[0].id
  name     = "barnes.biz"
  type     = "MX"
  ttl      = 60
  content  = "mx01.mail.icloud.com"
  priority = 10
}

resource "cloudflare_dns_record" "mx02" {
  zone_id  = data.cloudflare_zones.selected.result[0].id
  name     = "barnes.biz"
  type     = "MX"
  ttl      = 60
  content  = "mx02.mail.icloud.com"
  priority = 20
}
