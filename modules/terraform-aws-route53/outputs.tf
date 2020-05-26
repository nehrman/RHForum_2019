output "public_dns_zone_id" {
  description = "The IDs of DNS Zones"
  value       = aws_route53_zone.route53_new_public_zone.*.id
}

output "public_zone_aws_dns_name_servers" {
  description = "AWS DNS Name Servers"
  value       = aws_route53_zone.route53_new_public_zone.*.name_servers
}

output "public_dns_subzone_id" {
  description = "The IDs of DNS Zones"
  value       = aws_route53_zone.route53_new_public_subzone.*.id
}

output "public_subzone_aws_dns_name_servers" {
  description = "AWS DNS Name Servers"
  value       = aws_route53_zone.route53_new_public_subzone.*.name_servers
}

output "private_dns_zone_id" {
  description = "The IDs of DNS Zones"
  value       = aws_route53_zone.route53_new_private_zone.*.id
}

output "private_zone_aws_dns_name_servers" {
  description = "AWS DNS Name Servers"
  value       = aws_route53_zone.route53_new_private_zone.*.name_servers
}
