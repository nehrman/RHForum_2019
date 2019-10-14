output "lb_nlb_id" {
  description = "The IDs of Network Load Balancer"
  value       = "${aws_lb.nlb.*.id}"
}

output "lb_nlb_arn" {
  description = "The ARN of Network Load Balancer"
  value       = "${aws_lb.nlb.*.arn}"
}

output "lb_nlb_dns_name" {
  description = "The DNS Name of Network Load Balancer"
  value       = "${aws_lb.nlb.*.dns_name}"
}

output "lb_nlb_zone_id" {
  description = "The Zone ID of Network Load Balancer"
  value       = "${aws_lb.nlb.*.zone_id}"
}

output "lb_alb_id" {
  description = "The IDs of Application Load Balancer"
  value       = "${aws_lb.alb.*.id}"
}

output "lb_alb_arn" {
  description = "The ARN of Application Load Balancer"
  value       = "${aws_lb.alb.*.arn}"
}

output "lb_alb_dns_name" {
  description = "The DNS Name of Application Load Balancer"
  value       = "${aws_lb.alb.*.dns_name}"
}

output "lb_alb_zone_id" {
  description = "The Zone ID of Application Load Balancer"
  value       = "${aws_lb.alb.*.zone_id}"
}
