resource "aws_route53_record" "new" {
  count = "${length(var.instance_name) > 0 ? length(var.instance_name) : 0}"

  zone_id = "${var.zone_id}"
  name    = "${element(var.instance_name, count.index)}"
  type    = "${var.record_type}"
  ttl     = "${var.record_ttl}"
  records = ["${element(var.instance_ip, count.index)}"]
}
