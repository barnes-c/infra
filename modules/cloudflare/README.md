# Cloudflare Module

## What it does

- Creates root and wildcard A records for all configured zones (pointing to `192.168.1.201`)
- Sets up iCloud Mail for `barnes.biz` (MX, SPF, DKIM)
- Handles Apple domain verification for `barnes.biz`

## Variables

| Name                             | Type          | Description                                  | Default                    |
| -------------------------------- | ------------- | -------------------------------------------- | -------------------------- |
| `cloudflare_zones`               | `map(string)` | Map of logical zone names to DNS zone names  | `{ biz = "barnes.biz" }`   |
| `apple_domain_verification_code` | `string`      | Apple domain verification code (sensitive)   | required                   |

## DNS Records

### Per-zone (all zones)

| Record | Type | Content         |
| ------ | ---- | --------------- |
| `@`    | A    | `192.168.1.201` |
| `*`    | A    | `192.168.1.201` |

### barnes.biz only

| Record             | Type    | Content                                       |
| ------------------ | ------- | --------------------------------------------- |
| `@`                | TXT     | `apple-domain=<verification_code>`            |
| `@`                | TXT     | `v=spf1 include:icloud.com ~all`              |
| `@`                | MX (10) | `mx01.mail.icloud.com`                        |
| `@`                | MX (20) | `mx02.mail.icloud.com`                        |
| `sig1._domainkey`  | CNAME   | `sig1.dkim.barnes.biz.at.icloudmailadmin.com` |
