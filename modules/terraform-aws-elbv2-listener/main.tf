resource "aws_lb_listener" "new" {
  load_balancer_arn = "${var.load_balancer_arn}"

  port     = "${var.listener_port}"
  protocol = "${var.listener_protocol}"

  default_action {
    target_group_arn = "${var.target_group_arn}"
    type             = "${var.action_type}"
  }
}
