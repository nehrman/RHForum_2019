output "vpc_id" {
  description = "the ID of the VPC"
  value       = "${aws_vpc.vpc_new.id}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${aws_subnet.public.*.id}"]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${aws_subnet.public.*.cidr_block}"]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${aws_subnet.private.*.id}"]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${aws_subnet.private.*.cidr_block}"]
}

output "nat_gw_ids" {
  description = "List of NAT Gateway IDs"
  value       = ["${aws_nat_gateway.nat_gw.*.id}"]
}

output "nat_gw_public_ips" {
  description = "List of NAT Gateway Public IPs"
  value       = ["${aws_eip.eip.*.public_ip}"]
}
