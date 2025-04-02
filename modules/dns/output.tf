output "name" {
  value = cloudflare_dns_record.dns_record.name
  description = "Name of the created DNS record"
}