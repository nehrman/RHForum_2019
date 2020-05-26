resource "aws_route53_zone" "route53_new_public_zone" {
  count   = length(var.zone_id) == 0 ? length(var.public_zone_name) : 0
  name    = element(var.public_zone_name, count.index)
  comment = element(var.comment, count.index)
  tags    = var.tags
}

resource "aws_route53_zone" "route53_new_public_subzone" {
  count   = length(var.zone_id) > 0 ? length(var.public_subzone_name) : 0
  name    = element(var.public_zone_name, count.index)
  comment = element(var.comment, count.index)
  tags    = var.tags
}

resource "aws_route53_zone" "route53_new_private_zone" {
  count = length(var.private_zone_name) > 0 ? length(var.private_zone_name) : 0
  name  = element(var.private_zone_name, count.index)

  vpc {
    vpc_id = var.vpc_id
  }

  comment = element(var.comment, count.index)
  tags    = var.tags
}
