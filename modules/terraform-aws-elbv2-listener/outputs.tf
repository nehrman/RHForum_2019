output "aws_lb_listerner_arn" {
  description = "The ARN of the Listener"
  value       = "${aws_lb_listener.new.*.arn}"
}

output "aws_lb_listerner_id" {
  description = "The ID of the Listener"
  value       = "${aws_lb_listener.new.*.id}"
}
