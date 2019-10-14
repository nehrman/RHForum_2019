resource "aws_lb_target_group" "new" {
  name        = "${var.target_group_name}"
  port        = "${var.target_group_port}"
  protocol    = "${var.target_group_protocol}"
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.target_type}"

  tags = "${var.tags}"
}

resource "aws_lb_target_group_attachment" "new" {
  count            = "${length(var.instance_id)}"
  target_group_arn = "${aws_lb_target_group.new.arn}"
  target_id        = "${element(var.instance_id, count.index)}"
  port             = "${var.target_group_port}"
}
