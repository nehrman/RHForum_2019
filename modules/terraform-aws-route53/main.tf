resource "aws_route53_zone" "route53_new_zone" {
  count = "${length(var.public_zone_name) > 0 ? length(var.public_zone_name) : 0}"
  name = "${element(var.public_zone_name, count.index)}"
  comment = "${var.comment}"
  tags = "${var.tags}"
}