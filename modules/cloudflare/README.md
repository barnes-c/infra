# Cloudflare

This submodule contains the Infrastructure-as-Code (IaC) definitions for managing the [Cloudflare](https://cloudflare.com/) configuration of [**barnes.biz**](https://barnes.biz/).

## DNS Records

The Terraform configuration defines DNS records for:

- **Mail service** — MX, SPF, and DKIM records for iCloud Mail.
- **Root and wildcard domains** — `A` and `AAAA` records for both IPv4 and IPv6.
- **Domain verification** — TXT record used for Apple domain verification.

The actual domain is registered at [**Porkbun**](https://porkbun.com/), but DNS is managed through **Cloudflare**.  
Some records are **proxied** for traffic protection and performance, while others (like mail records) remain unproxied to ensure correct mail delivery.

## Notes

- The `A` and `AAAA` record values are managed by a separate Dynamic DNS (DyDNS) process. A Kubernetes CronJob runs every five minutes to update these records with the current public IP addresses.
