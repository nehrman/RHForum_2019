output "aws_acm_cert_arn" {
  description = "The ARN of the Certificate"
  value       = "${aws_acm_certificate.new.arn}"
}

output "aws_acm_cert_id" {
  description = "The ID of the Certificate"
  value       = "${aws_acm_certificate.new.id}"
}

output "aws_acm_domain_validation_options" {
  description = "List of information needed for Validation"
  value       = "${aws_acm_certificate.new.domain_validation_options}"
}

output "aws_acm_resource_record_name" {
  description = "List of resource_record_name needed for Validation"
  value       = "${aws_acm_certificate.new.domain_validation_options.0.resource_record_name}"
}

output "aws_acm_resource_record_type" {
  description = "List of resource_record_type needed for Validation"
  value       = "${aws_acm_certificate.new.domain_validation_options.0.resource_record_type}"
}

output "aws_acm_resource_record_value" {
  description = "List of resource_record_value needed for Validation"
  value       = "${aws_acm_certificate.new.domain_validation_options.0.resource_record_value}"
}
