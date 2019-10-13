output "instance_id" {
  description = "The ID of Instances"
  value       = "${aws_instance.vm.*.id}"
}

output "instance_public_dns" {
  description = "The Public DNS Name of Instances"
  value       = "${aws_instance.vm.*.public_dns}"
}

output "instance_public_ip" {
  description = "The Public IP address of Instances"
  value       = "${aws_instance.vm.*.public_ip}"
}

output "instance_primary_network_interface_id" {
  description = "The ID the primary network interface of Instances"
  value       = "${aws_instance.vm.*.primary_network_interface_id}"
}

output "instance_private_dns" {
  description = "The Private DNS Name of Instances"
  value       = "${aws_instance.vm.*.private_dns}"
}

output "instance_private_ip" {
  description = "The Private IP address of Instances"
  value       = "${aws_instance.vm.*.private_ip}"
}
