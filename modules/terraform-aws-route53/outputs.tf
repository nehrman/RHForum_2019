output "dns_zone_id" {
    description = "The IDs of DNS Zones"
    value = "${aws_route53_zone.route53_new_zone.*.id}"
}

output "aws_dns_name_servers" {
    description = "AWS DNS Name Servers"
    value = "${aws_route53_zone.route53_new_zone.*.name_servers}"
}

