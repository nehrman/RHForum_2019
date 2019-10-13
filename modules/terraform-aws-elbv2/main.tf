resource "aws_lb" "nlb" {
  count                            = "${var.lb_type == "network" ? 1: 0}"
  name                             = "${var.name}"
  internal                         = "${var.internal}"
  load_balancer_type               = "${var.lb_type}"
  security_groups                  = "${var.security_groups}"
  enable_deletion_protection       = "${var.enable_deletion_protection}"
  enable_cross_zone_load_balancing = "${var.enable_cross_zone_load_balancing}"
  ip_address_type                  = "${var.ip_address_type}"

  access_logs {
    bucket  = "${var.access_log_bucket}"
    prefix  = "${var.access_log_prefix}"
    enabled = "${var.access_log_enabled}"
  }

  tags = "${var.tags}"
}

resource "aws_lb" "alb" {
  count                      = "${var.lb_type == "application" ? 1: 0}"
  name                       = "${var.name}"
  internal                   = "${var.internal}"
  load_balancer_type         = "${var.lb_type}"
  security_groups            = ["${var.security_groups}"]
  idle_timeout               = "${var.idle_timeout}"
  enable_deletion_protection = "${var.enable_deletion_protection}"
  enable_http2               = "${var.enable_http2}"
  ip_address_type            = "${var.ip_address_type}"
  subnets                    = ["${var.subnets}"]

  access_logs {
    bucket  = "${var.access_log_bucket}"
    prefix  = "${var.access_log_prefix}"
    enabled = "${var.access_log_enabled}"
  }

  tags = "${var.tags}"
}
