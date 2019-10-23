resource "aws_acm_certificate" "new" {
  domain_name               = "${var.acm_domain_name}"
  subject_alternative_names = "${var.acm_san}"
  validation_method         = "${var.acm_validation_method}"

  tags = "${var.tags}"
}
