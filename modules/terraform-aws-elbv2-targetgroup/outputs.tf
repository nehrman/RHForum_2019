output "target_group_name" {
  description = "The name of the Target Group"
  value       = aws_lb_target_group.new.*.name
}

output "target_group_id" {
  description = "The ID of the Target Group"
  value       = aws_lb_target_group.new.*.id
}

output "target_group_arn" {
  description = "The ARN of the Target Group"
  value       = aws_lb_target_group.new.*.arn
}
