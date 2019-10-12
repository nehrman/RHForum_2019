output "sg_id" {
  description = "The IDs of Security Group"
  value       = "${aws_security_group.sg_new.id}"
}
