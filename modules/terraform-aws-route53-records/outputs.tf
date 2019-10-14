output "record_name" {
  description = "The name of the record"
  value       = "${aws_route53_record.new.*.name}"
}

output "record_fqdn" {
  description = "The FQDN of the record"
  value       = "${aws_route53_record.new.*.fqdn}"
}
