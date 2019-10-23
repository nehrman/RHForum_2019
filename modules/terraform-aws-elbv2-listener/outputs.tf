output "aws_lb_listener_arn" {
  description = "The ARN of the Listener"
  value       = "${aws_lb_listener.new.*.arn}"
}

output "aws_lb_listener_id" {
  description = "The ID of the Listener"
  value       = "${aws_lb_listener.new.*.id}"
}
