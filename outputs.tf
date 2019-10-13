output "vpc_id" {
  description = "the ID of the VPC"
  value       = "${module.aws_vpc.vpc_id}"
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = "${module.aws_vpc.public_subnets}"
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = "${module.aws_vpc.public_subnets_cidr_blocks}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = "${module.aws_vpc.private_subnets}"
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = "${module.aws_vpc.private_subnets_cidr_blocks}"
}

output "nat_gw_ids" {
  description = "List of NAT Gateway IDs"
  value       = "${module.aws_vpc.nat_gw_ids}"
}

output "nat_gw_public_ips" {
  description = ""
  value       = "${module.aws_vpc.nat_gw_public_ips}"
}

output "dns_zone_id" {
  description = "DNS Zone IDs"
  value       = "${module.aws_route53.dns_zone_id}"
}

output "aws_dns_name_servers" {
  description = "AWS DNS Name Servers"
  value       = "${module.aws_route53.aws_dns_name_servers}"
}

output "aws_sg_id_bastion" {
  description = "The ID of security group for Bastion"
  value       = "${module.aws_sg_bastion.sg_id}"
}

output "aws_sg_id_alb" {
  description = "The ID of security group for ALB"
  value       = "${module.aws_sg_alb.sg_id}"
}

#output "lb_alb_id" {
#  description = "The IDs of Application Load Balancer"
#  value       = "${module.aws_alb.lb_alb_id}"
#}
#
#output "lb_alb_dns_name" {
#  description = "The DNS Name of Application Load Balancer"
#  value       = "${module.aws_alb.lb_alb_dns_name}"
#}
#
#output "lb_alb_zone_id" {
#  description = "The Zone ID of Application Load Balancer"
#  value       = "${module.aws_alb.lb_alb_zone_id}"
#}

