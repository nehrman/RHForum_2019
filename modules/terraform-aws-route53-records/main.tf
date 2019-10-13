resource "aws_route53_record" "vault_route53_records" {
  count = "${var.vault_vm_count * (var.cloud_provider == "aws" ? 1 : 0)}"

  zone_id = "${aws_route53_zone.ec2_route53_zone.zone_id}"
  name    = "${lookup(aws_instance.vault_vm.*.tags[count.index], "Name")}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.vault_vm.*.public_ip, count.index)}"]
}
