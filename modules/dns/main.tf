resource "cloudflare_dns_record" "dns_record" {
  zone_id = var.zone_id
  content = var.content
  name    = "${var.name}.${var.domain}"
  proxied = var.proxied
  type    = var.type
  ttl     = 1
}

resource "cloudflare_page_rule" "redirect" {
  count = var.cname_forward == null ? 0 : 1
  zone_id = var.zone_id
  target  = "https://${var.name}.${var.domain}/*"

  actions = {
    forwarding_url = {
      url         = var.cname_forward
      status_code = 301
    }
  }

  priority = 1
  status   = "active"
}