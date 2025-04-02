resource "cloudflare_dns_record" "dns_record" {
  zone_id = var.zone_id
  content = var.ip_address
  name    = var.name
  proxied = var.proxied
  type    = var.type
  ttl     = 1
}